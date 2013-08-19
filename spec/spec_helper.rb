require 'rspec'
require 'active_support/core_ext'

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'lib', 'locomotivecms_liquid_extensions'))

Dir["#{File.expand_path('../support', __FILE__)}/*.rb"].each do |file|
  require file
end

RSpec.configure do |c|
  c.mock_with :mocha
end