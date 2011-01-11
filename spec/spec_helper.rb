require File.join(File.dirname(__FILE__), '..', 'lib', 'cabinet')
require 'forgery'

RSpec.configure do |config|
  config.before(:suite) do
    @@file_name    = 'cabinet.test'
    @@file_content = Forgery(:lorem_ipsum).text(:paragraphs, 10)
  end
end