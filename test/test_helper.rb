ENV['RAILS_ENV'] = 'test'

$:.unshift File.expand_path('../../lib', __FILE__)

require 'rubygems'

require 'test/unit'
require 'i18n'
require 'action_pack'
require 'active_support'
require 'action_controller'
require 'active_support/core_ext/enumerable.rb'
require 'test_declarative'
require 'routing_filter'
require 'routing_filter_locale_unless_api'

include RoutingFilter

class SomeController < ActionController::Base
end

class Test::Unit::TestCase
  def draw_routes(&block)
    ActionDispatch::Routing::RouteSet.new.tap { |set| set.draw(&block) }
  end
end
