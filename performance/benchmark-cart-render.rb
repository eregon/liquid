# frozen_string_literal: true

require_relative 'shopify/liquid'
require_relative 'shopify/database'

require_relative 'cab' unless respond_to?(:bench, true)

cart_template = Liquid::Template.new.parse(File.read(File.expand_path('tests/dropify/cart.liquid', __dir__)))
theme_template = Liquid::Template.new.parse(File.read(File.expand_path('tests/dropify/theme.liquid', __dir__)))

assigns = Database.tables
assigns['page_title']   = 'Page title'

bench do |input|
  assigns['x'] = input
  assigns['content_for_layout'] = cart_template.render!(assigns)
  theme_template.render!(assigns)
end
