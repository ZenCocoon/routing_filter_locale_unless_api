require 'routing_filter_locale_unless_api'

RSpec::configure do |config|
  config.color_enabled = true
end

include RoutingFilter

class SomeController < ActionController::Base
end

def draw_routes(&block)
  ActionDispatch::Routing::RouteSet.new.tap { |set| set.draw(&block) }
end