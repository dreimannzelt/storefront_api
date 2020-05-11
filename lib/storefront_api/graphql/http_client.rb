# frozen_string_literal: true
require 'shopify_api/graphql/http_client'

module StorefrontAPI
  module GraphQL
    class HTTPClient < ::ShopifyAPI::GraphQL::HTTPClient
      def headers(_context)
        StorefrontAPI::Base.headers
      end

      def uri
        ShopifyAPI::Base.site.dup.tap do |uri|
          uri.path = @api_version.construct_graphql_path.gsub('admin/', '')
        end
      end
    end
  end
end
