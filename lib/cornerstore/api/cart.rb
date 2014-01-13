class Cornerstore::Cart < Cornerstore::Model::Base
  include Cornerstore::Model::Writable

  attr_accessor :line_items, :reference, :total, :success_redirect_url, :cart_url, :invoice_pdf_callback_url,
    :delivery_note_pdf_callback_url, :placed_email_callback_url, :shipped_email_callback_url, :paid_email_callback_url, :canceled_email_callback_url

  def initialize(attributes = {}, parent=nil)
    self.total = Cornerstore::Price.new(attributes.delete('total'))
    self.line_items = Cornerstore::LineItem::Resource.new(self, attributes.delete('line_items') || [])
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

  def empty!
    line_items.delete_all
    line_items.empty?
  end

  def empty?
    line_items.empty?
  end

  def checkout_url
    "https://checkout.#{Cornerstore.options[:account_name]}.cornerstore.io/#{self.reference}"
  end

  class Resource < Cornerstore::Resource::Base
    include Cornerstore::Resource::Remote
    include Cornerstore::Resource::Writable
  end
end

module Cornerstore::SessionCart
  def self.included(base)
    base.send(:before_filter, :find_or_create_by_session)
  end

  def find_or_create_by_session(attributes = {})
    if not session[:cart_id] or not @cart = Cornerstore::Cart.find(session[:cart_id]) rescue nil
      @cart = Cornerstore::Cart.create(attributes)
      session[:cart_id] = @cart.id
    end
    @cart
  end
end