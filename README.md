# Routing Filter, Locale Unless API [![build status](http://travis-ci.org/ZenCocoon/routing_filter_locale_unless_api.png)](http://travis-ci.org/ZenCocoon/routing_filter_locale_unless_api)

RoutingFilterLocaleUnlessAPI is a extension filter to Sven Fuchs’s routing-filter

http://github.com/svenfuchs/routing-filter

RoutingFilterLocaleUnlessAPI filter extracts segments matching `/:locale` from
the beginning of the recognized path and exposes the locale parameter
as `params[:locale]`. When a path is generated the filter adds the segments
to the path accordingly if the locale parameter is passed to the url helper.

It will not add the locale parameter as a url fragment if:

* the format is `XML` or `JSON` (or any defined API format)
* with the root url and default locale

## Documentation

The [RDoc](http://rubydoc.info/gems/routing_filter_locale_unless_api/0.2.0/frames) provides
additional information for contributors and/or extenders.

All of the documentation is open source and a work in progress. If you find it
lacking or confusing, you can help improve it by submitting requests and
patches to the [routing_filter_locale_unless_api issue
tracker](https://github.com/ZenCocoon/routing_filter_locale_unless_api/issues).

## Requirements

Tested with Ruby 1.8.7, 1.9.2, 1.9.3, Ruby-head, REE and JRuby

    actionpack >= 3.0.9
    i18n >= 0.5.0
    routing-filter >= 0.2.3

## Installation

in your `Gemfile`

    gem 'routing_filter_locale_unless_api'

then in `config/routes.rb`

    Rails.application.routes.draw do
      filter :locale_unless_api
    end

## Usage

    incoming url: /fr/products
    filtered url: /products
    params: params[:locale] = 'fr'

    products_path(:locale => 'fr')
    generated_path: /fr/products

    products_path(:locale => 'fr', :format => 'xml')
    generated_path: /products.xml

    root_path(:locale => 'en')
    generated_path: /

    root_path(:locale => 'fr')
    generated_path: /fr

More example visible in the tests cases

## Configuration

You can customize the API formats with

    Rails.application.routes.draw do
      filter :locale_unless_api, :api_formats => %w( xml json xls )
    end

## Also see

* [http://github.com/svenfuchs/routing-filter](http://github.com/svenfuchs/routing-filter)

## License

MIT License. Copyright 2011 Sébastien Grosjean, sponsored by [BookingSync, Vacation Rental's Booking Calendar Software](http://www.bookingsync.com)
