class Cornerstore::AvailableShippingOption < Cornerstore::Model::Base

  attr_accessor :carrier,
    :additional_cost,
    :price_range,
    :weight_range,
    :based_on_id

  def initialize(attributes = {}, parent = nil, &block)
    self.carrier            = Cornerstore::Carrier.new(attributes.delete('carrier'))
    self.additional_cost    = Cornerstore::Price.new(attributes.delete('additional_cost'))              if attributes['additional_cost']
    self.price_range        = attributes['price_range']['min'].to_f..attributes['price_range']['max']   if attributes['price_range']
    self.weight_range       = attributes['weight_range']['min'].to_f..attributes['weight_range']['max'] if attributes['weight_range']

    super
  end

  # The rest of these methods is used to bind an available shipping
  # options to a specific cart
  include Cornerstore::Model::Writable

  # Available shipping options are used to tell Cornerstore which option
  # should be attached to an order, this is done by sending the id
  def wrapped_attributes
    puts 'here'
    { "shipping_option" => { "id" => self.id } }
  end

  def new?
    true
  end

  # Although shipping options are retrieved via cart/:id/available_shipping_options, and
  # this class is named accordingly, saving an actual option for a cart will be done via
  # the cart/:id/shipping_option endpoint
  def url(depth = 1)
    root = (@parent && depth > 0) ? @parent.url(depth-1) : Cornerstore.root_url
    "#{root}/shipping_option"
  end

  class Resource < Cornerstore::Resource::Base
    include Cornerstore::Resource::Remote
  end
end
