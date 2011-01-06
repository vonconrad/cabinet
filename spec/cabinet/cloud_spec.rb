require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Cabinet::Cloud do
  before(:all) do
    credentials = YAML.load_file(File.expand_path(File.join(File.dirname(__FILE__), '..', 'cloud_credentials.yml')))
    @cc         = Cabinet::Cloud.new({:container => 'cabinet_test'}.merge(credentials))
  end

  it "should create file" do
    @cc.put(@@file_name, @@file_content).should == true
  end

  it "should confirm file exists" do
    @cc.exists?(@@file_name).should == true
  end

  it "should confirm file does not exist" do
    @cc.exists?(@@file_content).should == false
  end

  it "should read file" do
    @cc.get(@@file_name).should == @@file_content
  end

  it "should list files"

  it "should not overwrite file"

  it "should overwrite file if :force => true"

  it "should gzip file"

  it "should delete file" do
    @cc.delete(@@file_name)
    @cc.exists?(@@file_name).should == false
  end

  it "should bulk delete files"
end