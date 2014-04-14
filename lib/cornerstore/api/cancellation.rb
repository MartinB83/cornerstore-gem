class Cornerstore::Cancellations < Cornerstore::Model::Base
  attr_accessor :created_at,
    :line_item_ids

  alias_method :canceled_at, :created_at

  def initialize(attributes = {}, parent=nil)
    self.line_item_ids = attributes.delete('canceled_items')
    super
  end

  def line_items
    return [] unless self.parent
    self.parent.line_items.select { |li| self.line_item_ids.include?(li.id) }
  end
  alias_method :canceled_items, :line_items

end