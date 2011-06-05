require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Cabinet::Instance do
  before(:all) do
    credentials = YAML.load_file(File.expand_path(File.join(File.dirname(__FILE__), '..', 'cloud_credentials.yml')))

    @local = Cabinet.local
    @local.directory = '/tmp/cabinet_test'

    @cloud = Cabinet.cloud(:rackspace, credentials)
    @cloud.container = 'cabinet_test'
    
    @file_name    = Forgery(:basic).text
    @file_content = Forgery(:lorem_ipsum).text(:paragraphs, 10)
  end

  after(:all) do
    @local.delete(/.*/)
  end

  it "should create file" do
    @local.put(@file_name, @file_content).should eql(true)
  end

  it "should confirm file exists" do
    @local.exists?(@file_name).should == true
  end

  it "should confirm file does not exist" do
    @local.exists?(@file_content).should == false
  end

  it "should read file" do
    @local.get(@file_name).should == @file_content
  end

  it "should get last modified" do
    @local.modified(@file_name).class.should == Time
  end

  it "should append file" do
    extra_content = Forgery(:lorem_ipsum).text(:paragraph)
    @local.append(@file_name, extra_content).should == true
    @local.get(@file_name).should == @file_content + extra_content
  end

  it "should list files" do
    @local.list.should include(@file_name)
    @local.list(/#{@file_name}/).should include(@file_name)
    @local.list(/#{@file_content}/).should == []
  end

  it "creates an empty file using put with empty content argument" do
    file = Forgery(:basic).text

    @local.put(file, nil).should eql(true)
    @local.get(file).should eql("")
  end

  it "creates an empty file using touch" do
    file = Forgery(:basic).text

    @local.touch(file).should eql(true)
    @local.get(file).should eql("")
  end

  it 'copies files from one cabinet instance to another'
 
  it "should delete file" do
    @local.delete(@file_name).should  == true
    @local.exists?(@file_name).should == false
  end
  
  it "should bulk delete files" do
    (1..3).each {|n| @local.put("#{@file_name}.#{n}", @file_content)}
    @local.delete(/#{@file_name}/)
    (1..3).inject([]) {|arr, n| arr << @local.exists?("#{@file_name}.#{n}")}.should == [false, false, false]
  end
end
