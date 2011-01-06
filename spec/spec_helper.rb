require File.join(File.dirname(__FILE__), '..', 'lib', 'cabinet')

RSpec.configure do |config|
  config.before(:suite) do
    @@file_name    = 'cabinet.test'
    @@file_content = (0...50).map{('a'..'z').to_a[rand(26)]}.join
  end
end