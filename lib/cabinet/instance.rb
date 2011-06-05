module Cabinet
  class Instance
    attr_accessor :connection, :directory

    def initialize(provider, auth={})
      fog_config      = auth.merge({:provider => fog_provider(provider)})
      self.connection = Fog::Storage.new(fog_config)
    end

    def directory=(name)
      @directory = connection.directories.get(name) || connection.directories.create(:key => name)
    end

    alias :container= :directory=
    alias :bucket=    :directory=

    def get(name)
      file(name).body
    end

    def list(regexp=/.*/)
      directory.files.reload
      directory.files.select{|f| f.key.match(regexp)}.to_a.map(&:key)
    end

    def put(name, content)
      content = content.to_s

      begin
        directory.files.create(:key => name, :body => content).content_length == content.length
      rescue
        false
      end
    end

    def touch(name)
      (exists?(name) ? put(name, get(name)) : put(name, "")) and !!reload(name)
    end

    def append(name, new_content)
      content = exists?(name) ? get(name) + new_content : new_content
      put(name, content) and !!reload(name)
    end

    def delete(name_or_regexp)
      @file = nil

      directory.files.reload

      if name_or_regexp.class == Regexp
        directory.files.select{|f| f.key.match(name_or_regexp)}.each do |file|
          file.destroy
        end
      else
        directory.files.get(name_or_regexp).destroy
      end

      true
    end

    def copy_to(klass, name)
      klass.put(name, get(name))
    end

    def exists?(name)
      !!file(name)
    end

    def modified(name)
      file(name).last_modified + 0 if exists?(name)
    end

    def gzip(name, content)
      name  = name.gsub(/(.+?)(\.gz)?$/, '\1.gz')
      local = "/tmp/#{name}"

      File.open(local, 'w') do |f|
        gz = Zlib::GzipWriter.new(f)
        gz.write content
        gz.close
      end

      put(name, File.read(local)) and File.unlink(local)
    end

    private
      def file(name)
        raise 'No directory specified' unless directory

        if @file && @file.key == name
          @file
        else
          reload(name)
        end
      end

      def reload(name)
        directory.files.reload
        @file = directory.files.get(name)
      end

      def fog_provider(provider)
        case provider.to_s.downcase
          when 'aws', 's3', 'amazon'
            'AWS'
          when 'rackspace', 'cloudfiles', 'cloud_files'
            'Rackspace'
          when 'google', 'google_storage'
            'Google'
          when 'local', 'localhost', 'filesystem'
            'Local'
          else
            raise ArgumentError, "#{provider} is not a valid provider"
        end
      end
  end
end