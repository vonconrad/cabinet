require 'cabinet'

describe Cabinet::Local do
  file_content = "Test content!"
  f = Cabinet::Local.new('/tmp')
  
  it "should create file" do
    f.put('cabinet.test', file_content).should eql(file_content.length)
  end
  
  it "should read file" do
    f.get('cabinet.test').should eql(file_content)
  end
end