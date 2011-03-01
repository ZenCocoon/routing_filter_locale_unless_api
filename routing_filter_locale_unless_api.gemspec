# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "routing_filter_locale_unless_api/version"

Gem::Specification.new do |s|
  s.name        = "routing_filter_locale_unless_api"
  s.version     = RoutingFilterLocaleUnlessApi::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Sébastien Grosjean"]
  s.email       = ["public@zencocoon.com"]
  s.homepage    = "https://github.com/ZenCocoon/routing_filter_locale_unless_api"
  s.summary     = %q{routing filter that add locale unless XML or JSON, or root_url with default locale}
  s.description = %q{A routing-filter additional filter that add locale unless XML or JSON, or root_url with default locale}

  s.rubyforge_project = "[none]"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency "routing-filter", "~> 0.2.3"
  s.add_development_dependency 'test_declarative'
end
