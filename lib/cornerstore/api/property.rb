class Cornerstore::Property < Cornerstore::Model::Base
  include Cornerstore::Model::Writable

  attr_accessor :key,
                :value
  
  def attributes
    {
      key: key,
      value: value
    }
  end
  
  # TODO: Rewrite #url on base model to automatically detect parent/url depth.
  def url
    super(2)
  end
  
  def initialize(attributes = {}, parent = nil)
    @key = attributes.delete(:key)
    @value = attributes.delete(:value)
        
    super
  end
  
  class Resource < Cornerstore::Resource::Base
    include Cornerstore::Resource::Remote
    include Cornerstore::Resource::Writable
  end
end