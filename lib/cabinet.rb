require 'fog'
require 'cabinet/instance'

module Cabinet
  unless const_defined?(:VERSION)
    VERSION = '0.2.1'
  end

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
