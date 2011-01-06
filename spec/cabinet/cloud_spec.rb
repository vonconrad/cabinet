require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Cabinet::Cloud do
  before(:all) do
    credentials   = YAML.load_file(File.expand_path(File.join(File.dirname(__FILE__), '..', 'cloud_credentials.yml')))
    @cc           = Cabinet::Cloud.new({:container => 'cabinet_test'}.merge(credentials))
    @file_name    = 'cabinet.test'
    @file_content = (0...50).map{('a'..'z').to_a[rand(26)]}.join
  end
end