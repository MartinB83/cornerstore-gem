class Cornerstore::Variant < Cornerstore::Model::Base
  attr_accessor :order_number,
                :price,
                :qty_in_stock,
                :qty_reserved,
                :offer,
                :oversell,
                :weight,
                :unit,
                :properties,
                :differentiating_properties

  alias product parent
  alias offer? offer

  def attributes
    {
      order_number: order_number,
      price: price,
      qty_in_stock: qty_in_stock,
      qty_reserved: qty_reserved,
      offer: offer,
      oversell: oversell,
      weight: weight,
      unit: unit
    }
  end

  def initialize(attributes = {}, parent = nil)
    self.price                      = Cornerstore::Price.new(attributes.delete('price'))
    self.properties                 = Cornerstore::Property::Resource.new(self, attributes.delete('properties') || [])
    self.differentiating_properties = Cornerstore::DifferentiatingProperty::Resource.new(self, attributes.delete('differentiating_properties') || [])

    super
  end

  def qty_available
    if self.qty_in_stock and not self.oversell
      self.qty_in_stock - self.qty_reserved
    else
      Float::INFINITY
    end
  end

  def sold_out?
    self.qty_available == 0
  end

  class Resource < Cornerstore::Resource::Base
  end
end
