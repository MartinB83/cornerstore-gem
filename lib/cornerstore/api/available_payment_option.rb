class Cornerstore::AvailablePaymentOption < Cornerstore::Model::Base

  attr_accessor :payment_means,
    :human_name,
    :additional_cost,
    :price_range,
    :weight_range,
    :return_url,
    :cancel_url,
    :card_token,
    :issuer,
    :last_digits

  def initialize(attributes = {}, parent = nil, &block)
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
    base = { "payment_option" => { "id" => self.id } }

    case self.payment_means
    when 'StripeCreditCardTransaction'
      base['payment_means/stripe_credit_card_transaction'] = {
        card_token: self.card_token,
        issuer: self.issuer,
        last_digits: self.last_digits
      }
    end

    base
  end

  def new?
    true
  end

  # Although payment options are retrieved via cart/:id/available_payment_options, and
  # this class is named accordingly, saving an actual option for a cart will be done via
  # the cart/:id/payment_option endpoint
  def url(depth = 1)
    root = (@parent && depth > 0) ? @parent.url(depth-1) : Cornerstore.root_url
    "#{root}/payment_option"
  end

  class Resource < Cornerstore::Resource::Base
    include Cornerstore::Resource::Remote
  end
end
