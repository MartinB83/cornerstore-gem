class Cornerstore::Order < Cornerstore::Model::Base
  attr_accessor :number,
    :reference,
    :checkout_id,
    :placed_at,
    :invoice_number,
    :invoiced_at,
    :checkout_started_at,
    :requested_carrier,
    :weight,
    :subtotal,
    :shipping_costs,
    :payment_costs,
    :sales_tax,
    :total,
    :customer_comment,

    :customer,
    :shipping_address,
    :billing_address,
    :payment_means,
    :requested_carrier,
    :line_items,
    :shipments,
    :cancellations

  def initialize(attributes, parent=nil)
    self.payment_costs      = Cornerstore::Price.new(attributes.delete('payment_costs')) if attributes['payment_costs']
    self.shipping_costs     = Cornerstore::Price.new(attributes.delete('shipping_costs')) if attributes['shipping_costs']
    self.subtotal           = Cornerstore::Price.new(attributes.delete('subtotal'))
    self.sales_tax          = Cornerstore::Price.new(attributes.delete('sales_tax')) if attributes['sales_tax']
    self.total              = Cornerstore::Price.new(attributes.delete('total'))

    self.customer           = Cornerstore::Customer.new(attributes.delete('customer'))
    self.shipping_address   = Cornerstore::Address.new(attributes.delete('shipping_address'))
    self.billing_address    = Cornerstore::Address.new(attributes.delete('billing_address'))
    self.payment_means      = Cornerstore::PaymentMeans.new(attributes.delete('payment_means'))
    self.requested_carrier  = Cornerstore::Carrier.new(attributes.delete('requested_carrier'))

    self.line_items         = Cornerstore::LineItem::Resource.new(self, attributes.delete('line_items') || [], 'line_items')
    self.shipments          = Cornerstore::Shipment::Resource.new(self, attributes.delete('shipments') || [], 'shipments')
    self.cancellations      = Cornerstore::Cancellation::Resource.new(self, attributes.delete('cancellations') || [], 'cancellations')

    self.placed_at          = DateTime.parse(attributes.delete('placed_at')) unless attributes['placed_at'].blank?
    self.invoiced_at        = DateTime.parse(attributes.delete('invoiced_at')) unless attributes['invoiced_at'].blank?

    super
  end

  def requires_shipment?
    self.line_items.any? { |li| li.requires_shipment? }
  end

  # Returns true if at least one line item of this order is shipped
  def shipped?
    !self.shipments.empty?
  end

  # Returns true if at least one line item of this order is canceled
  def canceled?
    !self.cancellations.empty?
  end

  def invoiced?
    !self.invoice_number.blank?
  end

  # Returns true if all line items are shipped
  def completely_shipped?
    self.shipments.collect(&:shipped_items).flatten.size == self.line_items.size
  end

  # Returns true if all line items are canceled
  def completely_canceled?
    self.cancellations.collect(&:canceled_items).flatten.size == self.line_items.size
  end

  def handling_costs
    if self.shipping_costs or self.payment_costs
      (self.shipping_costs || 0) + (self.payment_costs || 0)
    end
  end

  def check_signature
    # TODO: Implement signature check
    return true
  end
end
