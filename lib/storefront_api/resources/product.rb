module StorefrontAPI
  class Product < Base
    FindByHandleQuery = <<~GRAPHQL
      query($handle: String!) {
        productByHandle(handle: $handle) {
          id
          handle
          title
          description
          priceRange {
            minVariantPrice {
              amount
              currencyCode
            }
            maxVariantPrice {
              amount
              currencyCode
            }
          }
          variants(first: 1) {
            edges {
              node {
                id
                title
              }
            }
          }
          images(first: 5) {
            edges {
              node {
                transformedSrc(maxWidth: 1234)
              }
            }
          }
          collections(first: 1) {
            edges {
              node {
                id
                handle
                title
              }
            }
          }
          availableForSale
        }
      }
    GRAPHQL

    SearchQuery = <<~GRAPHQL
      query($query: String!) {
        products(query: $query, first: 4) {
          edges {
            node {
              id
              handle
              title
              description
              priceRange {
                minVariantPrice {
                  amount
                  currencyCode
                }
                maxVariantPrice {
                  amount
                  currencyCode
                }
              }
              variants(first: 1) {
                edges {
                  node {
                    id
                    title
                  }
                }
              }
              images(first: 5) {
                edges {
                  node {
                    transformedSrc(maxWidth: 1234)
                  }
                }
              }
              collections(first: 1) {
                edges {
                  node {
                    id
                    handle
                    title
                  }
                }
              }
              availableForSale
            }
          }
        }
      }
    GRAPHQL

    #=== Class Methods

    class << self
      def find_by_handle(handle)
        new(
          query(
            FindByHandleQuery, 
            variables: { 
              handle: handle
            }
          ).data.product_by_handle
        )
      end

      def search(term)
        query(
          SearchQuery,
          variables: {
            query: term
          }
        ).data.products.edges.map do |product_connection|
          new(
            product_connection
          )
        end
      end
    end

    #=== Instance Methods

    delegate :id,
            :title, 
            :handle,
            :description,
            :available_for_sale,
            :price_range,
            to: :data

    def variants
      self.data.variants.edges.map do |product_variant_connection|
        Storefront::ProductVariant.new(
          product_variant_connection.node
        )
      end
    end

    def selected_variant
      self.variants.first
    end

    def images
      self.data.images.edges.map do |image_connection|
        Storefront::Image.new(
          image_connection.node
        )
      end
    end

    def collection_handle
      @collection_handle ||= self.data.collections.edges.first.node.handle
    end

    def collection
      @collection ||= Storefront::Collection.find_by_handle(
        self.collection_handle
      )
    end
    
    def tags
      return [] unless @data.respond_to?(:tags)
      @data.tags
    end

    def to_s
      self.title
    end

    def to_param
      self.handle
    end
  end
end
