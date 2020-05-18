module StorefrontAPI
  class ProductEdge < Base
    def product
      Product.new(self.data)
    end
  end
end
