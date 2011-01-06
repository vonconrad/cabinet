module Cabinet
  class Local
    attr_accessor :dir

    def initialize(root_dir)
      self.dir = root_dir.chomp('/') + '/'
    end

    def get(file)
      raise ArgumentError, "The file #{file} does not exist" unless exists?(file)
      File.read(dir + file)
    end

    def put(file, content)
      File.open(dir + file, 'wb') {|f| f.write(content)} == content.length
    end

    def delete(file_or_regexp)
      File.delete *Dir.glob(dir + file_or_regexp)
    end

    def exists?(file)
      File.exists?(dir + file)
    end

    def gzip(file, content)
      File.open(dir + file, 'w') do |f|
        gz = Zlib::GzipWriter.new(f)
        gz.write content
        gz.close
      end
    end
  end
end
