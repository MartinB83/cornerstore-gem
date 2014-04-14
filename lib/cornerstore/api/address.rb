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
end