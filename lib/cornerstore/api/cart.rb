class Cornerstore::Cart < Cornerstore::Model::Base
  include Cornerstore::Model::Writable

  attr_accessor :line_items,
    :reference,
    :total,
    :subtotal,
    :shipping_costs,
    :payment_costs,
    :sales_tax,
    :success_redirect_url,
    :cart_url,
    :invoice_pdf_callback_url,
    :delivery_note_pdf_callback_url,
    :placed_email_callback_url,
    :shipped_email_callback_url,
    :paid_email_callback_url,
    :canceled_email_callback_url,

    :customer,
    :available_shipping_options,
    :shipping_address,
    :billing_address,
    :available_billing_options,
    :payment_means,
    :requested_carrier,
    :shipments

  def initialize(attributes = {}, parent=nil, &block)
    self.total            = Cornerstore::Price.new(attributes.delete('total'))
    self.payment_costs    = Cornerstore::Price.new(attributes.delete('payment_costs')) if attributes['payment_costs']
    self.shipping_costs   = Cornerstore::Price.new(attributes.delete('shipping_costs')) if attributes['shipping_costs']
    self.subtotal         = Cornerstore::Price.new(attributes.delete('subtotal'))
    self.sales_tax        = Cornerstore::Price.new(attributes.delete('sales_tax')) if attributes['sales_tax']

    self.customer         = Cornerstore::Customer.new(attributes.delete('customer'), self)
    self.line_items       = Cornerstore::LineItem::Resource.new(self, attributes.delete('line_items') || [], 'line_items')
    self.billing_address  = Cornerstore::BillingAddress.new(attributes.delete('billing_address') || nil, self)
    self.shipping_address = Cornerstore::ShippingAddress.new(attributes.delete('shipping_address') || nil, self)
    super
  end

  def id
    reference
  end
  alias to_param id

  def attributes
    {
      reference: reference,
      success_redirect_url: success_redirect_url,
      cart_url: cart_url,
      invoice_pdf_callback_url: invoice_pdf_callback_url,
      delivery_note_pdf_callback_url: delivery_note_pdf_callback_url,
      placed_email_callback_url: placed_email_callback_url,
      shipped_email_callback_url: shipped_email_callback_url,
      paid_email_callback_url: paid_email_callback_url,
      canceled_email_callback_url: canceled_email_callback_url
    }
  end

  def create_customer(attributes = {})
    self.customer ||= Cornerstore::Customer.new
    self.customer.attributes = attributes
    self.customer.save

    return self.customer
  end

  def create_billing_address(attributes = {})
    self.billing_address ||= Cornerstore::BillingAddress.new
    self.billing_address.attributes = attributes
    self.billing_address.save

    return self.billing_address
  end

  def create_shipping_address(attributes = {})
    self.shipping_address ||= Cornerstore::ShippingAddress.new
    self.shipping_address.attributes = attributes
    self.shipping_address.save

    return self.shipping_address
  end

  def empty!
    line_items.delete_all
    line_items.empty?
  end

  def empty?
    line_items.empty?
  end

  def checkout_url
    "https://#{Cornerstore.subdomain}.cornerstore.io/checkout/#{self.reference}"
  end

  class Resource < Cornerstore::Resource::Base
    include Cornerstore::Resource::Remote
    include Cornerstore::Resource::Writable
  end
end
