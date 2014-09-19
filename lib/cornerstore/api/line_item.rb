class Cornerstore::LineItem < Cornerstore::Model::Base
  include Cornerstore::Model::Writable

  attr_accessor :order_number,
                :description,
                :qty,
                :unit,
                :price,
                :total,
                :weight,
                :properties,
                :product,
                :variant,
                :product_id,
                :variant_id

  alias cart parent

  validates :order_number, length: { within: 1..50 }
  validates :description, length: { within: 1..255 }
  validates :qty, numericality: { greater_than: 0, only_integer: true }
  validates :unit, length: { within: 1..20 }
  validates :price, presence: true
  validates :weight, numericality: { greater_than: 0, allow_nil: true }
  validate do
    errors.add(:price, 'Price must be valid') unless price.valid?
  end

  def initialize(attributes = {}, parent = nil)
    self.price = Cornerstore::Price.new(attributes.delete('price'))
    self.total = Cornerstore::Price.new(attributes.delete('total'))
    self.properties = Cornerstore::Property::Resource.new(self, attributes.delete('properties') || [])
    self.product = Cornerstore::Product.new(attributes.delete('product')) if attributes['product']
    self.variant = Cornerstore::Variant.new(attributes.delete('variant'), self.product) if attributes['variant']
    super
  end

  def attributes
    {
      order_number: order_number,
      description: description,
      qty: qty,
      unit: unit,
      price: price.attributes,
      weight: weight
    }
  end

  class Resource < Cornerstore::Resource::Base
    include Cornerstore::Resource::Remote
    include Cornerstore::Resource::Writable

    def create_from_variant(variant, attr={})
      attributes = {
        variant_id: variant.id,
        product_id: variant.product._id,
        line_item: attr
      }

      RestClient.post("#{Cornerstore.root_url}/carts/#{@parent.id}/line_items/derive.json", attributes, Cornerstore.headers) do |response, request, result, &block|
        if response.code == 201
          attributes = ActiveSupport::JSON.decode(response)
          line_item = @klass.new(attributes, @parent)
        elsif response.code == 422 and data = ActiveSupport::JSON.decode(response) and data.has_key?('errors')
          line_item = @klass.new(attr, @parent)
          data['errors'].each_pair do |key, messages|
            messages.map { |message| line_item.errors.add(key, message) }
          end
        end

        push line_item
        line_item
      end
    end
  end
end
