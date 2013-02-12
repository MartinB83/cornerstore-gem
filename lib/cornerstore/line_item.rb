class Cornerstore::LineItem < Cornerstore::Writable
  attr_accessor :order_number,
                :description,
                :qty,
                :unit,
                :price,
                :weight
                
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
  
  def initialize(attributes={}, parent=nil)
    self.price = Cornerstore::Price.new(attributes.delete('price'))
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
  
  class Resource < Cornerstore::WritableResource
    def create_from_variant(variant)
      attributes = {
        variant_id: variant.id,
        product_id: variant.product.id
      }
      response = RestClient.post("#{Cornerstore.root_url}/carts/#{@parent.id}/line_items/derive.json", attributes)  
      attributes = ActiveSupport::JSON.decode(response)
      line_item = @klass.new(attributes)
      push line_item
      line_item
    end
  end
end