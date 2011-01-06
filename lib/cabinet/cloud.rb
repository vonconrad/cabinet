require 'fog'

module Cabinet
  class Cloud
    attr_accessor :connection, :container

    def initialize(config)
      root_dir        = config.delete(:container)
      self.connection = Fog::Rackspace::Storage.new(config)
      self.container  = connection.directories.get(root_dir) || connection.directories.create(:key => root_dir)
    end

    def get(name)
      file(name).body
    end

    def list(regexp)
      container.files.reload
      container.files.select{|f| f.key.match(regexp)}.to_a
    end

    def put(name, content)
      begin
        container.files.create(:key => name, :body => content).content_length == content.length
      rescue
        false
      end
    end

    def delete(name_or_regexp)
      @file = nil

      container.files.reload

      if name_or_regexp.class == Regexp
        container.files.select{|f| f.key.match(name_or_regexp)}.each do |file|
          file.destroy
        end
      else
        container.files.get(name_or_regexp).destroy
      end

      true
    end

    def copy_to_filesystem(name)
      File.open("#{Rails.root}/tmp/#{name}", 'wb') { |f| f.write(get(name)) }
      "#{Rails.root}/tmp/#{name}"
    end

    def exists?(name)
      !!file(name)
    end

    def gzip(name, content)
      name  = name.gsub(/(.+?)(\.gz)?$/, '\1.gz')
      local = "#{Rails.root}/tmp/#{name}"

      File.open(local, 'w') do |f|
        gz = Zlib::GzipWriter.new(f)
        gz.write content
        gz.close
      end

      put(name, File.read(local)) and File.unlink(local)
    end

    private
      def file(name)
        if @file && @file.key == name
          @file
        else
          container.files.reload
          @file = container.files.get(name)
        end
      end
  end
end