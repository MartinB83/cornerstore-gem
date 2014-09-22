class Cornerstore::BillingAddress < Cornerstore::Address
  include Cornerstore::Model::Writable
  include Cornerstore::Model::Singleton

  def order=(order)
    self.parent = order
  end

  def cart=(order)
    self.parent = order
  end

  alias :order :parent
  alias :cart :parent
end
