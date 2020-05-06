$:.unshift File.dirname(__FILE__)
require 'storefront_api/version'

module StorefrontAPI
  class Error < StandardError; end
end

require 'storefront_api/graphql'
require 'storefront_api/graphql/railtie' if defined?(Rails)
