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

  it "should list files" do
    @cc.list.should include(@@file_name)
    @cc.list(/#{@@file_name}/).should include(@@file_name)
    @cc.list(/#{@@file_content}/).should == []
  end

  it "should copy file to local filesystem using object" do
    cl = Cabinet::Local.new('/tmp')
    cl.delete(@@file_name) if cl.exists?(@@file_name)

    @cc.copy_to(cl, @@file_name)
    cl.exists?(@@file_name).should == true
    cl.delete(@@file_name)
  end

  it "should copy file to local filesystem using symbol" do
    File.unlink("/tmp/#{@@file_name}") if File.exists?("/tmp/#{@@file_name}")
    @cc.copy_to(:local, @@file_name)
    File.exists?("/tmp/#{@@file_name}").should == true
    File.unlink("/tmp/#{@@file_name}")
  end

  it "should not overwrite file"

  it "should overwrite file if :force => true"

  it "should gzip file"

  it "should delete file" do
    @cc.delete(@@file_name)
    @cc.exists?(@@file_name).should == false
  end

  it "should bulk delete files"
end