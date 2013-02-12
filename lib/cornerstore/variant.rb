class Cornerstore::Variant < Cornerstore::Base
  attr_accessor :order_number,
                :price
                
  alias product parent
                
  def initialize(attributes = {}, parent=nil)
    self.price = Cornerstore::Price.new(attributes.delete('price'))
    super
  end
  
  class Resource < Cornerstore::Resource
    NESTED = true
  end
end