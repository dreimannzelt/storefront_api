$:.unshift File.dirname(__FILE__)
#require 'shopify_api'
require 'active_resource'
require 'active_support/core_ext/class/attribute_accessors'
require 'storefront_api/version'

module StorefrontAPI
  class Error < StandardError; end
end


require 'storefront_api/resources'

require 'storefront_api/graphql'
require 'storefront_api/graphql/railtie' if defined?(Rails)
