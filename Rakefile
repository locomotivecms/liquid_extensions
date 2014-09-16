require 'bundler/gem_tasks'
require 'rubygems/package_task'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks
RSpec::Core::RakeTask.new(:spec)

gemspec = eval(File.read('locomotivecms_liquid_extensions.gemspec'))
Gem::PackageTask.new(gemspec) do |pkg|
  pkg.gem_spec = gemspec
end


task default: :spec