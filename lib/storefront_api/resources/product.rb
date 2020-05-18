module StorefrontAPI
  class Product < Base
    #=== Class Methods

    class << self
      def all(per_page: 50, cursor: nil)
        Pagination.new(
          query(
            Queries::Product::AllQuery,
            variables: {
              perPage: per_page
            }
          ).data.products,
          Product,
        )
      end

      def find(handle)
        new(
          query!(
            Queries::Product::FindByHandleQuery, 
            variables: { 
              handle: handle
            },
            required_node: :product_by_handle
          )
        )
      end

      def search(term)
        query(
          Queries::Product::SearchQuery,
          variables: {
            query: term
          }
        )
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

    def price
      self.price_range.min_variant_price.amount
    end

    def currency
      self.price_range.min_variant_price.currency_code
    end

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
      Pagination.new(
        self.data.images,
        Image
      )
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
