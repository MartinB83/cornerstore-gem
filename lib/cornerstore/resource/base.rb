class Cornerstore::Resource::Base
  include Enumerable
  attr_accessor :parent

  def initialize(parent = nil, ary = nil, name = nil)
    @klass = Cornerstore.const_get(self.class.name.split('::')[-2])
    @name = name
    @parent = parent
    @filters = Hash.new
    @objects = Array.new
    from_array(ary) if ary.is_a? Array
  end

  def from_array(ary)
    @objects = ary.map{|h| @klass.new(h, @parent)}
    @load = true
  end

  def find(*args)
    ids = Array.new(args).flatten.compact.uniq
    case ids.size
      when 0
        raise "Couldn't find #{@klass.name} without an ID"
      when 1
        find_by_id_or_param(ids.first)
      else
        find_by_ids(ids)
    end
  end

  def find_by_id_or_param(id_or_param)
    find_by_id id_or_param.to_s
  end

  def find_by_id(id)
    @objects.find{|obj| obj._id == id}
  end

  def find_by_ids(*args)
    ids = Array.new(args).flatten.compact.uniq
    all.select{|item| ids.include? item._id }
  end

  def all
    self.clone
  end

  def push(obj)
    @objects << obj
    obj.parent = @parent
    self
  end
  alias_method :<<, :push

  def to_a
    @objects
  end
  alias_method :to_ary, :to_a

  def each(&block)
    to_a.each(&block)
  end

  def size
    @objects.size
  end
  alias_method :count, :size
  alias_method :length, :size

  def empty?
    @objects.empty?
  end

  alias blank? empty?

  def method_missing(method, *args, &block)
    if Cornerstore::Resource::Writable.method_defined?(method)
      raise "Sorry, this part of the Cornerstore-API is currently read-only"
    else
      super
    end
  end
end