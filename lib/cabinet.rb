require 'pathname'

module Cabinet; end

dir = Pathname(__FILE__).dirname.expand_path
require dir + 'cabinet/cloud'
require dir + 'cabinet/local'