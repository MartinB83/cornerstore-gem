class Cornerstore::Customer < Cornerstore::Model::Base
  include Cornerstore::Model::Writable
  include Cornerstore::Model::Singleton

  attr_accessor :email,
                :phone,
                :tax_number

  def attributes
    {
      email: self.email,
      phone: self.phone,
      tax_number: self.tax_number
    }
  end

  def order=(order)
    self.parent = order
  end

  def cart=(order)
    self.parent = order
  end

  alias :order :parent
  alias :cart :parent
end
