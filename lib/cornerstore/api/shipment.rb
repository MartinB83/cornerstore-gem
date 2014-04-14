class Cornerstore::Shipment < Cornerstore::Model::Base
  attr_accessor :carrier,
    :tracking_number,
    :created_at,
    :line_item_ids

  alias_method :shipped_at, :created_at

  def initialize(attributes = {}, parent=nil)
    self.carrier  = Cornerstore::Carrier.new(attributes.delete('carrier'))
    self.line_item_ids = attributes.delete('shipped_items')
    super
  end

  def line_items
    return [] unless self.parent
    self.parent.line_items.select { |li| self.line_item_ids.include?(li.id) }
  end
  alias_method :shipped_items, :line_items


  class Resource < Cornerstore::Resource::Base
  end
end