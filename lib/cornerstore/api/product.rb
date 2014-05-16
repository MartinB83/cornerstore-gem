class Cornerstore::Product < Cornerstore::Model::Base
  attr_accessor :name,
                :description,
                :manufacturer,
                :enabled,
                :variants,
                :images,
                :properties

  def initialize(attributes = {}, parent = nil)
    self.images     = Cornerstore::Image::Resource.new(self, attributes.delete('images') || [], 'images')
    self.variants   = Cornerstore::Variant::Resource.new(self, attributes.delete('variants') || [], 'variants')
    self.properties = Cornerstore::Property::Resource.new(self, attributes.delete('properties') || [], 'properties')
    super
  end

  def attributes
    {
      name: name,
      description: description,
      manufacturer: manufacturer,
      enabled: enabled
    }
  end

  def price
    variants.collect { |v| v.price }.sort.first
  end

  def order_number
    variants.many? ? :many : variants.first.order_number
  end

  def sold_out?
    variants.all? { |v| v.sold_out? }
  end

  def offer?
    variants.any? { |v| v.offer? }
  end

  def new?
    self.created_at >= 2.weeks.ago
  end

  def cover_image
    @cover_image ||= self.images.to_a.find {|i| i.cover == true }
  end

  class Resource < Cornerstore::Resource::Base
    include Cornerstore::Resource::Remote
    include Cornerstore::Resource::Filter

    def enabled
      self.clone.set_filter(:enabled, true)
    end

    def by_collection(collection_id)
      self.clone.tap{|r| r.parent = Cornerstore::Collection.find(collection_id)}
    end
    alias find_by_collection by_collection

    def order(key)
      first = %w(name popularity created_at price)
      second = %w(desc asc)
      pattern = /\A(#{first.join('|')})( (#{second.join('|')}))?\z/i
      raise "order key must be one of: #{first.join(', ')} [#{second.join(', ')}]" unless key.match pattern
      super
    end
    alias order_by order
  end
end