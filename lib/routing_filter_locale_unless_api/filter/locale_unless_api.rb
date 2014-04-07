require 'i18n'

module RoutingFilterLocaleUnlessAPI
  module Filter
    class LocaleUnlessApi < RoutingFilter::Filter
      @@api_formats = %w( xml json )
      cattr_writer :api_formats, :exclude

      # Class Methods
      class << self
        # Returns +true+ if the given format is considered as an API, otherwise +false+.
        #
        # @param [String,Symbol] format
        #
        # @return [Boolean]
        def api_format?(format)
          format && @@api_formats.include?(format.to_s.downcase)
        end

        # Returns all available locales
        #
        # @return [Array]
        def locales
          @@locales ||= I18n.available_locales.map(&:to_sym)
        end

        # Set locales.
        #
        # @param [Array] locales
        #
        # @return [Array]
        #   locales as an Array of Symbols
        def locales=(locales)
          @@locales = locales.map(&:to_sym)
        end

        # Define the locales pattern.
        #
        # @return [Regexp]
        def locales_pattern
          @@locales_pattern ||= %r(^/(#{self.locales.map { |l| Regexp.escape(l.to_s) }.join('|')})(?=/|$))
        end
      end

      # Extract locale segments from the URL.
      #
      # @param [String] path
      #   Current path to recognize, might have been modified by previous filters
      #
      # @param [Hash] env
      #   Current environment
      #
      # @yield
      #   Additional filters and finally routing
      def around_recognize(path, env, &block)
        locale = extract_segment!(self.class.locales_pattern, path) # remove the locale from the beginning of the path
        yield.tap do |params|                                       # invoke the given block (calls more filters and finally routing)
          params[:locale] = locale if locale                        # set recognized locale to the resulting params hash
        end
      end

      # Add locale segments to the generated URL if required.
      #
      # @param *args
      #   Resources and Params given for the route generation
      #
      # @yield
      #   Additional filters
      def around_generate(*args, &block)
        params = args.extract_options!                              # this is because we might get a call like forum_topics_path(forum, topic, :locale => :en)

        format = params[:format]                                    # save the current format
        locale = params.delete(:locale)                             # extract the passed :locale option
        locale = nil unless valid_locale?(locale)                   # reset to no locale when locale is not valid
        locale = I18n.locale if locale.nil?                         # default to I18n.locale when locale is nil (could also be false)

        args << params

        yield.tap do |result|
          prepend_segment!(result, locale) if prepend_locale?(result, locale, format)
        end
      end

      protected

        # Returns true if the locale is valid.
        #
        # @param [Symbol,String] locale
        #
        # @return [Boolean]
        def valid_locale?(locale)
          locale && self.class.locales.include?(locale.to_sym)
        end

        # Returns true if the locale is the default one.
        #
        # @param [Symbol,String] locale
        #
        # @return [Boolean]
        def default_locale?(locale)
          locale && locale.to_sym == I18n.default_locale.to_sym
        end

        # Returns true if root path.
        #
        # @param [String] path
        #
        # @return [Boolean]
        def root_path?(path)
          (path.is_a?(Array) ? path.first : path) == '/'
        end

        # Returns true if it should prepend the locale
        #
        # @param [String] path
        # @param [Symbol,String] locale
        # @param [String,Symbol] format
        #
        # @return [Boolean]
        def prepend_locale?(path, locale, format)
          locale && !self.class.api_format?(format) && !(root_path?(path) && default_locale?(locale)) && !excluded?(path)
        end

        # Returns true if path should be excluded based on :exclude option
        #
        # @param [String|Array] path
        # @return [Boolean]
        def excluded?(path)
          path = path.is_a?(Array) ? path.first : path
          case @@exclude
          when Regexp
            path =~ @@exclude
          when Proc
            @@exclude.call(path)
          end
        end
    end
  end
end
