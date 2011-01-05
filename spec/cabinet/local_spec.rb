require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Cabinet::Local do
  before(:all) do
    @cl           = Cabinet::Local.new('/tmp')
    @file_name    = 'cabinet.test'
    @file_content = (0...50).map{('a'..'z').to_a[rand(26)]}.join
  end

  it "should create file" do
    @cl.put(@file_name, @file_content).should == @file_content.length
  end

  it "should confirm file exists" do
    @cl.exists?(@file_name).should == true
  end
  
  it "should confirm file does not exist" do
    @cl.exists?(@file_content).should == false
  end

  it "should read file" do
    @cl.get(@file_name).should == @file_content
  end

  it "should list files" do
  end

  it "should not overwrite file" do
  end

  it "should overwrite file if :force => true" do
  end

  it "should gzip file" do
    gz_file_name = @file_name + '.gz'
    @cl.gzip(gz_file_name, @file_content)
    Zlib::GzipReader.open("/tmp/#{gz_file_name}") {|gz| gz.read}.should == @file_content
    @cl.delete(gz_file_name)
  end

  it "should delete file" do
    @cl.delete(@file_name)
    @cl.exists?(@file_name).should == false
  end

  it "should bulk delete files" do
    (1..3).each {|n| @cl.put("#{@file_name}.#{n}", @file_content)}
    @cl.delete("#{@file_name}*")
    (1..3).inject([]) {|arr, n| arr << @cl.exists?("#{@file_name}.#{n}")}.should == [false, false, false]
  end
end