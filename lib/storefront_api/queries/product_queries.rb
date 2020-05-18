module StorefrontAPI
  module Queries
    module Product
      AllQuery = Base.parse <<~GRAPHQL
        query($perPage: Int) {
          products(first: $perPage) {
            edges {
              cursor
              node {
                id
                handle
                title
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
                images(first: 1) {
                  edges {
                    node {
                      transformedSrc(maxWidth: 1234)
                    }
                  }
                }
              }
            }
            pageInfo {
              hasNextPage
              hasPreviousPage
            }
          }
        }
      GRAPHQL

      FindByHandleQuery = Base.parse <<~GRAPHQL
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

      SearchQuery = Base.parse <<~GRAPHQL
        query($query: String!) {
          products(query: $query) {
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
                images(first: 1) {
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
    end
  end
end

StorefrontAPI::Product.include StorefrontAPI::Queries::Product
