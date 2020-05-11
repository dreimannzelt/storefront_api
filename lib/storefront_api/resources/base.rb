require 'storefront_api/version'

module StorefrontAPI
  class Base < ActiveResource::Base
    self.headers['User-Agent'] = ["StorefrontAPI/#{StorefrontAPI::VERSION}",
                                  "ShopifyAPI/#{ShopifyAPI::VERSION}",
                                  "Ruby/#{RUBY_VERSION}"].join(' ')
    
    class << self
      threadsafe_attribute(:token)

      def default_headers
        {
          'X-Shopify-Storefront-Access-Token': StorefrontAPI::Base.token
        }
      end

      def headers
        if _headers_defined?
          _headers.merge(default_headers)
        elsif superclass != Object && superclass.headers
          superclass.headers.merge(default_headers)
        else
          _headers ||= {}.merge(default_headers)
        end
      end

      def api_version
        ShopifyAPI::Base.api_version
      end

      def parse(string)
        StorefrontAPI::GraphQL.client.parse string
      end

      def query(query, *options)
        StorefrontAPI::GraphQL.client.query query, *options
      end
    end
  end
end
