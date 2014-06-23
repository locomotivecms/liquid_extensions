require 'solid'
require 'pony'
require 'net/http'

%w{tags filters}.each do |dir|
  Dir[File.join(File.dirname(__FILE__), 'liquid_extensions', dir, '*.rb')].each { |lib| require lib }
end

# DEBUG
# puts "[LocomotiveLiquidExtensions] tags and filters loaded"
