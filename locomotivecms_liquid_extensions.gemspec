#!/usr/bin/env gem build
# encoding: utf-8

lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'locomotive/liquid_extensions/version'

Gem::Specification.new do |s|
  s.name        = 'locomotivecms_liquid_extensions'
  s.version     = Locomotive::LiquidExtensions::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Didier Lafforgue']
  s.email       = ['did@locomotivecms.com']
  s.homepage    = 'http://www.locomotivecms.com'
  s.summary     = 'LocomotiveCMS Liquid Extensions'
  s.description = 'Extra liquid tags, filters for LocomotiveCMS'

  s.required_rubygems_version = '>= 1.3.6'
  s.rubyforge_project         = 'locomotivecms_liquid_extensions'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'activesupport', '~> 3'

  s.add_dependency 'pony',                  '~> 1.8'
  s.add_dependency 'locomotivecms-solid',   '~> 0.2.2.1'

  # hosting (LocomotiveCMS engine)
  # s.add_dependency 'locomotivecms_solid', '~> 0.2.2'

  s.require_path = 'lib'

  s.files        = Dir.glob('lib/**/*')
end

