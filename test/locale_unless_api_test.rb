require File.expand_path('../test_helper', __FILE__)

class LocaleUnlessApiTest < Test::Unit::TestCase
  attr_reader :routes, :root, :params

  def setup
    I18n.locale = nil
    I18n.default_locale = :en
    I18n.available_locales = %w(fr en)

    RoutingFilter::LocaleUnlessApi.api_formats = %w( xml json )

    @root   = { :controller => 'some', :action => 'index' }
    @params = { :controller => 'some', :action => 'show', :id => '1' }

    @routes = draw_routes do
      filter :locale_unless_api
      match 'products/:id', :to => 'some#show'
      root :to => 'some#index'
    end
  end

  test 'recognizes the path /en/products/1' do
    assert_equal params.merge(:locale => 'en'), routes.recognize_path('/en/products/1')
  end

  test 'recognizes the path /fr/products/1' do
    assert_equal params.merge(:locale => 'fr'), routes.recognize_path('/fr/products/1')
  end
  
  test 'recognizes the path /products/1.xml' do
    assert_equal params.merge(:format => 'xml'), routes.recognize_path('/products/1.xml')
  end

  test 'recognizes the path /products/1.json' do
    assert_equal params.merge(:format => 'json'), routes.recognize_path('/products/1.json')
  end
  
  test 'recognizes the path /en' do
    assert_equal root.merge(:locale => 'en'), routes.recognize_path('/en/')
  end
  
  test 'recognizes the path /fr' do
    assert_equal root.merge(:locale => 'fr'), routes.recognize_path('/fr')
  end
  
  test 'recognizes the path /' do
    assert_equal root, routes.recognize_path('/')
  end


  test 'prepends the segments /:locale to the generated path if the current locale is not the default locale' do
    I18n.locale = 'fr'
    assert_equal '/fr/products/1', routes.generate(params)
  end
  
  test 'prepends the segments /:locale to the generated path even if the current locale is not the default locale' do
    I18n.locale = 'en'
    assert_equal '/en/products/1', routes.generate(params)
  end
  
  test 'does not prepend the segments /:locale to the generated path if the current locale is the default locale and with root url' do
    I18n.locale = 'en'
    assert_equal '/', routes.generate(root)
  end
  
  test 'prepends the segments /:locale to the generated path if the current locale is not the default locale and with root url' do
    I18n.locale = 'fr'
    assert_equal '/fr', routes.generate(root)
  end
  
  test 'does not prepend the segments /:locale to the generated path if the format XML is considered as api' do
    I18n.locale = 'fr'
    assert_equal '/products/1.xml', routes.generate(params.merge(:format => 'xml'))
  end
  
  test 'does not prepend the segments /:locale to the generated path if the format JSON is considered as api' do
    I18n.locale = 'fr'
    assert_equal '/products/1.json', routes.generate(params.merge(:format => 'json'))
  end
  
  test 'prepends the segments /:locale to the generated path if the format XLS is not considered as api' do
    I18n.locale = 'fr'
    assert_equal '/fr/products/1.xls', routes.generate(params.merge(:format => 'xls'))
  end
  
  test 'does not prepend the segments /:locale to the generated path if the format XLS is considered as api' do
    I18n.locale = 'fr'
    RoutingFilter::LocaleUnlessApi.api_formats = %w( xml json xls )
    assert_equal '/products/1.xls', routes.generate(params.merge(:format => 'xls'))
  end
  
  test 'should work with format as symbol' do
    assert_equal '/products/1.xml', routes.generate(params.merge(:format => :xml))
  end


  test 'prepends the segments /:locale to the generated path if the given locale is not the default locale' do
    assert_equal '/fr/products/1', routes.generate(params.merge(:locale => 'fr'))
  end
  
  test 'prepends the segments /:locale to the generated path even if the given locale is the default locale' do
    assert_equal '/en/products/1', routes.generate(params.merge(:locale => 'en'))
  end
  
  test 'does not prepend the segments /:locale to the generated path if the given locale is the default locale and with root url' do
    assert_equal '/', routes.generate(root.merge(:locale => 'en'))
  end
  
  test 'prepends the segments /:locale to the generated path if the given locale is not the default locale and with root url' do
    assert_equal '/fr', routes.generate(root.merge(:locale => 'fr'))
  end
  
  test 'does not prepend the segments /:locale to the generated path if a given locale and the format XML is considered as api' do
    assert_equal '/products/1.xml', routes.generate(params.merge(:format => 'xml', :locale => 'fr'))
  end
  
  test 'does not prepend the segments /:locale to the generated path if a given locale and the format JSON is considered as api' do
    assert_equal '/products/1.json', routes.generate(params.merge(:format => 'json', :locale => 'fr'))
  end
  
  test 'prepends the segments /:locale to the generated path if a given locale and the format XLS is not considered as api' do
    assert_equal '/fr/products/1.xls', routes.generate(params.merge(:format => 'xls', :locale => 'fr'))
  end
  
  test 'does not prepend the segments /:locale to the generated path if a given locale and the format XLS is considered as api' do
    RoutingFilter::LocaleUnlessApi.api_formats = %w( xml json xls )
    assert_equal '/products/1.xls', routes.generate(params.merge(:format => 'xls', :locale => 'fr'))
  end
end