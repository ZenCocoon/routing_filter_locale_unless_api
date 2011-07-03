require 'spec_helper'

module RoutingFilterLocaleUnlessAPI::Filter
  describe LocaleUnlessApi do
    before do
      I18n.locale = nil
      I18n.default_locale = :en
      I18n.available_locales = %w(fr en)

      RoutingFilter::LocaleUnlessApi.api_formats = %w( xml json )
    end

    let(:root) { { :controller => 'some', :action => 'index' } }
    let(:params) { { :controller => 'some', :action => 'show', :id => '1' } }
    let(:routes) do
      draw_routes do
        filter :locale_unless_api
        match 'products/:id', :to => 'some#show'
        root :to => 'some#index'
      end
    end

    context "path recognition" do
      it 'should recognize /en/products/1' do
        params.merge(:locale => 'en').should == routes.recognize_path('/en/products/1')
      end

      it 'should recognize /fr/products/1' do
        params.merge(:locale => 'fr').should == routes.recognize_path('/fr/products/1')
      end

      it 'should recognize /products/1.xml' do
        params.merge(:format => 'xml').should == routes.recognize_path('/products/1.xml')
      end

      it 'should recognize /products/1.json' do
        params.merge(:format => 'json').should == routes.recognize_path('/products/1.json')
      end

      it 'should recognize /en' do
        root.merge(:locale => 'en').should == routes.recognize_path('/en/')
      end

      it 'should recognize /fr' do
        root.merge(:locale => 'fr').should == routes.recognize_path('/fr')
      end

      it 'should recognize /' do
        root.should == routes.recognize_path('/')
      end
    end

    context "route generation" do
      context "with locale set" do
        before(:each) do
          I18n.locale = 'fr'
        end

        context "prepends the segments /:locale to the generated path" do
          it 'if the current locale is not the default locale' do
            routes.generate(params).should == '/fr/products/1'
          end

          it 'if the current locale is the default locale' do
            I18n.locale = 'en'
            routes.generate(params).should == '/en/products/1'
          end

          it 'if the current locale is not the default locale and with root url' do
            routes.generate(root).should == '/fr'
          end

          it 'if the format XLS is not considered as api' do
            routes.generate(params.merge(:format => 'xls')).should == '/fr/products/1.xls'
          end
        end

        context "does not prepend the segments /:locale to the generated path" do
          it 'if the current locale is the default locale and with root url' do
            I18n.locale = 'en'
            routes.generate(root).should == '/'
          end

          it 'if the format XML is considered as api' do
            routes.generate(params.merge(:format => 'xml')).should == '/products/1.xml'
          end

          it 'if the format JSON is considered as api' do
            routes.generate(params.merge(:format => 'json')).should == '/products/1.json'
          end

          it 'if the format XLS is considered as api' do
            RoutingFilter::LocaleUnlessApi.api_formats = %w( xml json xls )
            routes.generate(params.merge(:format => 'xls')).should == '/products/1.xls'
          end
        end

        it 'should work with format as symbol' do
          routes.generate(params.merge(:format => :xml)).should == '/products/1.xml'
        end
      end

      context "with locale as param" do
        let(:params) { { :controller => 'some', :action => 'show', :id => '1', :locale => 'fr' } }

        context "prepends the segments /:locale to the generated path" do
          it 'if the given locale is not the default locale' do
            routes.generate(params).should == '/fr/products/1'
          end

          it 'if the given locale is the default locale' do
            routes.generate(params.merge(:locale => 'en')).should == '/en/products/1'
          end

          it 'if the given locale is not the default locale and with root url' do
            routes.generate(root.merge(:locale => 'fr')).should == '/fr'
          end

          it 'if a given locale and the format XLS is not considered as api' do
            routes.generate(params.merge(:format => 'xls')).should == '/fr/products/1.xls'
          end
        end

        context "does not prepend the segments /:locale to the generated path" do
          it 'if a given locale is the default locale and with the root url' do
            routes.generate(root.merge(:locale => 'en')).should == '/'
          end

          it 'if a given locale and the format XML is considered as api' do
            routes.generate(params.merge(:format => 'xml')).should == '/products/1.xml'
          end

          it 'if a given locale and the format JSON is considered as api' do
            routes.generate(params.merge(:format => 'json')).should == '/products/1.json'
          end

          it 'if a given locale and the format XLS is considered as api' do
            RoutingFilter::LocaleUnlessApi.api_formats = %w( xml json xls )
            routes.generate(params.merge(:format => 'xls')).should == '/products/1.xls'
          end
        end
      end
    end
  end
end