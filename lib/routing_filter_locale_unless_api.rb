require 'routing_filter'
require 'action_controller'
require 'routing_filter_locale_unless_api/filter/locale_unless_api'
require 'routing_filter_locale_unless_api/version'

# RoutingFilterLocaleUnlessAPI is a extension filter to Sven Fuchs’s routing-filter
#
# http://github.com/svenfuchs/routing-filter
#
# RoutingFilter::LocaleUnlessAPI filter extracts segments matching +/:locale+ from
# the beginning of the recognized path and exposes the locale parameter
# as +params[:locale]+. When a path is generated the filter adds the segments
# to the path accordingly if the locale parameter is passed to the url helper.
#
# It will not add the locale parameter as a url fragment if:
#
# * the format is +XML+ or +JSON+ (or any defined API format)
# * with the root url and default locale
#
# === Install:
#
# in your +Gemfile+
#
#   gem 'routing_filter_locale_unless_api'
#
# then in +config/routes.rb+
#
#   Rails.application.routes.draw do
#     filter :locale_unless_api
#   end
#
# @example
#   incoming url: /fr/products
#   filtered url: /products
#   params: params[:locale] = 'fr'
#
#   products_path(:locale => 'fr')
#   generated_path: /fr/products
#
#   products_path(:locale => 'fr', :format => 'xml')
#   generated_path: /products.xml
#
#   root_path(:locale => 'en')
#   generated_path: /
#
#   root_path(:locale => 'fr')
#   generated_path: /fr
#
# === Configuration
#
# You can customize the API formats with
#
#    Rails.application.routes.draw do
#      filter :locale_unless_api, :api_formats => %w( xml json xls )
#    end
module RoutingFilterLocaleUnlessAPI
end

module RoutingFilter
  include RoutingFilterLocaleUnlessAPI::Filter
end
