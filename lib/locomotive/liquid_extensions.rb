require 'solid'
require 'pony'

%w{tags filters}.each do |dir|
  Dir[File.join(File.dirname(__FILE__), 'liquid_extensions', dir, '*.rb')].each { |lib| require lib }
end

Liquid::Template.register_filter(Locomotive::LiquidExtensions::Filters::Math)

# DEBUG
# puts "[LocomotiveLiquidExtensions] tags and filters loaded"