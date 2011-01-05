require 'cabinet'

describe Cabinet::Local do
  cl           = Cabinet::Local.new('/tmp')
  file_name    = 'cabinet.test'
  file_content = (0...50).map{('a'..'z').to_a[rand(26)]}.join

  it "should create file" do
    cl.put(file_name, file_content).should eql(file_content.length)
  end

  it "should confirm file exists" do
    cl.exists?(file_name).should eql(true)
  end
  
  it "should confirm file does not exist" do
    random_string = file_content
    cl.exists?(random_string).should eql(false)
  end

  it "should read file" do
    cl.get(file_name).should eql(file_content)
  end

  it "should delete file" do
    cl.delete(file_name)
    cl.exists?(file_name).should eql(false)
  end
end