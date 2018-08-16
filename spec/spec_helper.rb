$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'simplecov'
require 'simplecov-rcov'

if(SimpleCov)
  SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
  SimpleCov.start
end

require 'sendsecure-ruby'
require 'test_utils'
