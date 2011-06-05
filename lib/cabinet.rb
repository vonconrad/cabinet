require 'pathname'
require 'fog'

module Cabinet
  def self.cloud(provider, options={})
    self.init(provider, options)
  end

  def self.local(path='/')
    self.init(:local, {:local_root => path})
  end
  
  def self.init(*args)
    Cabinet::Instance.new(*args)
  end
end

dir = Pathname(__FILE__).dirname.expand_path
require dir + 'cabinet/instance'