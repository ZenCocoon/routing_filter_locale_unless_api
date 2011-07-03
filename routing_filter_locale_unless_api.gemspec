# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'routing_filter_locale_unless_api/version'

Gem::Specification.new do |s|
  s.name        = "routing_filter_locale_unless_api"
  s.version     = RoutingFilterLocaleUnlessAPI::Version::STRING
  s.platform    = Gem::Platform::RUBY
  s.authors     = "Sébastien Grosjean"
  s.email       = "public@zencocoon.com"
  s.homepage    = "https://github.com/ZenCocoon/routing_filter_locale_unless_api"
  s.summary     = %q{routing filter that add locale unless XML or JSON, or root_url with default locale}
  s.description = %q{A routing-filter additional filter that add locale unless XML or JSON, or root_url with default locale}

  s.files             = `git ls-files`.split("\n")
  s.test_files        = `git ls-files -- {spec,features}/*`.split("\n")
  s.extra_rdoc_files  = "README.md"
  s.rdoc_options      = "--charset=UTF-8"
  s.require_paths     = "lib"

  s.add_dependency "actionpack", "~> 3.0.9"
  s.add_dependency "i18n", ">= 0.5.0"
  s.add_dependency "routing-filter", "~> 0.2.3"

  s.add_development_dependency "rake", "~> 0.9"
  s.add_development_dependency 'rspec', '~> 2.6.0'
  s.add_development_dependency "cucumber", "1.0.0"
  s.add_development_dependency "guard-rspec", "0.1.9"
  s.add_development_dependency 'guard-cucumber', "~> 0.5.1"
  s.add_development_dependency "growl", "1.0.3"
  s.add_development_dependency 'yard', "~> 0.7.2"
  s.add_development_dependency "appraisal", '~> 0.3.6'
end
