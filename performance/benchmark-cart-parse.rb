# frozen_string_literal: true

require_relative 'shopify/liquid'

require_relative 'cab' unless respond_to?(:bench, true)

cart_template_source = File.read(File.expand_path('tests/dropify/cart.liquid', __dir__))

bench do |input|
  Liquid::Template.new.parse(cart_template_source + input.to_s)
end
