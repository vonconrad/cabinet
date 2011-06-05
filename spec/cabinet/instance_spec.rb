require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Cabinet::Instance do
  before(:all) do
    @local = Cabinet.local
    @local.directory = '/tmp/cabinet_test'

    @file_name    = Forgery(:basic).text
    @file_content = Forgery(:lorem_ipsum).text(:paragraphs, 10)
  end

  after(:all) do
    @local.delete(/.*/)
  end

  it "creates files" do
    @local.put(@file_name, @file_content).should == true
  end

  it "confirms that files exists" do
    @local.exists?(@file_name).should == true
  end

  it "confirms that files don't exist" do
    @local.exists?(@file_content).should == false
  end

  it "reads file content" do
    @local.get(@file_name).should == @file_content
  end

  it "fetches last modified timestamp" do
    @local.modified(@file_name).class.should == Time
  end

  it "appends files" do
    extra_content = Forgery(:lorem_ipsum).text(:paragraph)
    @local.append(@file_name, extra_content).should == true
    @local.get(@file_name).should == @file_content + extra_content
  end

  it "list files with (and without) regular expressions" do
    @local.list.should include(@file_name)
    @local.list(/#{@file_name}/).should include(@file_name)
    @local.list(/#{@file_content}/).should == []
  end

  it "creates an empty file using put with empty content argument" do
    file = Forgery(:basic).text

    @local.put(file, nil).should == true
    @local.get(file).should == ""
  end

  it "creates an empty file using touch" do
    file = Forgery(:basic).text

    @local.touch(file).should == true
    @local.get(file).should == ""
  end

  it "copies files from one cabinet instance to another" do
    new_local = Cabinet.local
    new_local.directory = "/tmp/cabinet_test_2"

    @local.copy_to(new_local, @file_name).should == true
    new_local.get(@file_name).should == @local.get(@file_name)

    new_local.delete(@file_name)
  end

  it "updates last_modified timestamp using touch" do
    original_time    = @local.modified(@file_name)
    original_content = @local.get(@file_name)

    sleep(1) # to force time to pass update

    @local.touch(@file_name).should == true
    @local.modified(@file_name).should_not == original_time
    @local.get(@file_name).should == original_content
  end

  it "compresses files using gzip" do
    gz_file_name = @file_name + '.gz'

    @local.compress(gz_file_name, @file_content).should == true
    Zlib::GzipReader.new(StringIO.new(@local.get(gz_file_name))).read.should == @file_content
  end

  it "decompresses files using gzip" do
    gz_file_name = @file_name + '.gz'
    @local.decompress(gz_file_name).should == @file_content
  end

  it "deletes files" do
    @local.delete(@file_name).should  == true
    @local.exists?(@file_name).should == false
  end
  
  it "bulk deletes files using regular expressions" do
    (1..3).each {|n| @local.put("#{@file_name}.#{n}", @file_content)}
    @local.delete(/#{@file_name}/)
    (1..3).inject([]) {|arr, n| arr << @local.exists?("#{@file_name}.#{n}")}.should == [false, false, false]
  end

  it "tests cloud connection" do
    credentials = YAML.load_file(File.expand_path(File.join(File.dirname(__FILE__), '..', 'cloud_credentials.yml')))
    cloud = Cabinet.cloud(:rackspace, credentials)
    cloud.container = 'cabinet_test'

    cloud.put(@file_name, @file_content).should == true
    cloud.list.should include(@file_name)
    cloud.list(/#{@file_name}/).should include(@file_name)
    cloud.get(@file_name).should == @file_content
    cloud.delete(@file_name).should == true
    cloud.list.should_not include(@file_name)
  end
end
