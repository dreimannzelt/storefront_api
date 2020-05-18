require 'storefront_api/version'

module StorefrontAPI
  class Base #< ActiveResource::Base
    extend ActiveModel::Naming
    include ActiveModel::Conversion
    # self.headers['User-Agent'] = ["StorefrontAPI/#{StorefrontAPI::VERSION}",
    #                               "ShopifyAPI/#{ShopifyAPI::VERSION}",
    #                               "Ruby/#{RUBY_VERSION}"].join(' ')
    
    class << self
      # threadsafe_attribute(:token)
      attr_accessor :token

      def default_headers
        {
          'X-Shopify-Storefront-Access-Token': StorefrontAPI::Base.token
        }
      end

      def headers
        # if _headers_defined?
        #   _headers.merge(default_headers)
        # elsif superclass != Object && superclass.headers
        #   superclass.headers.merge(default_headers)
        # else
        #   _headers ||= {}.merge(default_headers)
        # end
        {
          'User-Agent': ["StorefrontAPI/#{StorefrontAPI::VERSION}",
                         "ShopifyAPI/#{ShopifyAPI::VERSION}",
                          "Ruby/#{RUBY_VERSION}"].join(' ')
        }.merge(default_headers)
      end

      def api_version
        ShopifyAPI::Base.api_version
      end
      
      def parse(string)
        StorefrontAPI::GraphQL.client.parse string
      end

      def query(query_definition, variables: {}, required_node: nil)
        response = StorefrontAPI::GraphQL.client.query(query_definition, variables: variables)
        node_from_response = required_node ? response.data.try(required_node) : nil

        if required_node.present?
          return node_from_response
        end

        response
      end

      def query!(query_definition, variables: {}, required_node:)
        response = query(query_definition, variables: variables, required_node: required_node)
        
        if response.blank?
          raise RequiredNodeEmpty.new("Required node #{required_node} was empty") 
        end

        response
      end
    end

    attr_reader :data
    attr_reader :cursor
    attr_reader :errors

    def initialize(response)
      @data   = response.try(:data) || response.try(:node) || response
      @cursor = response.try(:cursor)
      @errors = response.try(:errors)
    end

    def persisted?
      true
    end
  end
end
