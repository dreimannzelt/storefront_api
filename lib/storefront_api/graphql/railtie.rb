# frozen_string_literal: true
require 'rails/railtie'

module StorefrontAPI
  module GraphQL
    class Railtie < Rails::Railtie
      initializer 'storefront_api.initialize_graphql_clients' do |app|
        StorefrontAPI::GraphQL.schema_location = app.root.join('db', StorefrontAPI::GraphQL.schema_location)
        StorefrontAPI::GraphQL.initialize_clients
      end

      rake_tasks do
        load 'storefront_api/graphql/task.rake'
      end
    end
  end
end
