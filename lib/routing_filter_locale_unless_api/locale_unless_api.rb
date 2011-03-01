# The LocaleUnlessAPI filter is an extension to Sven Fuchs's routing-filter
# 
# https://github.com/svenfuchs/routing-filter
# 
# LocaleUnlessAPI filter extracts segments matching /:locale from the beginning of
# the recognized path and exposes the locale parameter as params[:locale]. When a
# path is generated the filter adds the segments to the path accordingly if
# the locale parameter is passed to the url helper.
# 
# It will not add the locale parameter as a url fragment if:
# 
# * the format is XML or JSON
# * with the root url and default locale
# 
# incoming url: /fr/products
# filtered url: /products
# params: params[:locale] = 'fr'
# 
# products_path(:locale => 'fr')
# generated_path: /fr/products
# 
# You can install the filter like this:
#
# in config/routes.rb
# 
# Rails.application.routes.draw do
#   filter :locale_unless_api
# end

require 'i18n'

module RoutingFilter
  class LocaleUnlessApi < Filter
    @@api_formats = %w( xml json )
    cattr_writer :api_formats

    class << self
      def api_format?(format)
        format && @@api_formats.include?(format.to_s.downcase)
      end
      
      def locales
        @@locales ||= I18n.available_locales.map(&:to_sym)
      end

      def locales=(locales)
        @@locales = locales.map(&:to_sym)
      end

      def locales_pattern
        @@locales_pattern ||= %r(^/(#{self.locales.map { |l| Regexp.escape(l.to_s) }.join('|')})(?=/|$))
      end
    end

    def around_recognize(path, env, &block)
      locale = extract_locale!(path)                 # remove the locale from the beginning of the path
      yield.tap do |params|                          # invoke the given block (calls more filters and finally routing)
        params[:locale] = locale if locale           # set recognized locale to the resulting params hash
      end
    end

    def around_generate(*args, &block)
      options = args.extract_options!
      format = options[:format]                      # copy format
      locale = options.delete(:locale)               # extract the passed :locale option
      locale = I18n.locale if locale.nil?            # default to I18n.locale when locale is nil (could also be false)
      locale = nil unless valid_locale?(locale)      # reset to no locale when locale is not valid

      yield.tap do |result|
        prepend_locale!(result, locale) if prepend_locale?(result, locale, format)
      end
    end

    protected

      def extract_locale!(path)
        path.sub!(self.class.locales_pattern, '')
        $1
      end

      def valid_locale?(locale)
        locale && self.class.locales.include?(locale.to_sym)
      end

      def default_locale?(locale)
        locale && locale.to_sym == I18n.default_locale.to_sym
      end
      
      def root_path?(result)
        result == '/'
      end

      def prepend_locale?(result, locale, format)
        locale && !self.class.api_format?(format) && !(root_path?(result) && default_locale?(locale))
      end

      def prepend_locale!(result, locale)
        url = result.is_a?(Array) ? result.first : result
        url.sub!(%r(^(http.?://[^/]*)?(.*))) {
          $2 == '/' ? "#{$1}/#{locale}" : "#{$1}/#{locale}#{$2}"
        }
      end
  end
end
