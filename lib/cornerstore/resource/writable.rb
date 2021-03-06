module Cornerstore::Resource::Writable
  def destroy_all
    @objects.delete_if { |obj| obj.destroy }
    self
  end

  def new(attributes = {}, &block)
    @klass.new(attributes, &block).tap{ |obj| push obj }
  end

  def create(attributes = {}, &block)
    obj = @klass.new(attributes, @parent, &block)
    self.push(obj) if obj.save
    return obj
  end
end
