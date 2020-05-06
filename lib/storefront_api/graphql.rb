# frozen_string_literal: true
require 'graphql/client'
require 'shopify_api/graphql/http_client'

module StorefrontAPI
  module GraphQL
    include ShopifyAPI::GraphQL
    DEFAULT_SCHEMA_LOCATION_PATH = Pathname('shopify_storefront_graphql_schemas')

    class << self
      delegate :parse, :query, to: :client

      def client(api_version = ShopifyAPI::Base.api_version.handle)
        initialize_client_cache
        cached_client = @_client_cache[api_version]

        if cached_client
          cached_client
        else
          schema_file = schema_location.join("#{api_version}.json")

          if !schema_file.exist?
            raise InvalidClient, <<~MSG
              Client for API version #{api_version} does not exist because no schema file exists at `#{schema_file}`.

              To dump the schema file, use the `rake storefront_api:graphql:dump` task.
            MSG
          else
            puts '[WARNING] Client was not pre-initialized. Ensure `StorefrontAPI::GraphQL.initialize_clients` is called during app initialization.'
            initialize_clients
            @_client_cache[api_version]
          end
        end
      end
    end
  end
end
