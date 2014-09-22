class Cornerstore::Address < Cornerstore::Model::Base
  attr_accessor :firstname,
                :name,
                :company,
                :street,
                :number,
                :addition,
                :town,
                :zip,
                :country,
                :state

  def attributes
    {
      firstname: self.firstname,
      name: self.name,
      company: self.company,
      street: self.street,
      number: self.number,
      addition: self.addition,
      town: self.town,
      zip: self.zip,
      state: self.state,
      country: self.country
    }
  end
end
