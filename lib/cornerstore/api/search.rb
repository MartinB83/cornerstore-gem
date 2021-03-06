class Cornerstore::Search
  extend ActiveModel::Naming

  attr_accessor :keywords, :products, :scores
  alias :results :products

  def initialize(keywords = nil)
    @keywords, @scores, @products = keywords, Array.new, Cornerstore::Product::Resource.new
  end

  def results?
    !@products.empty?
  end

  def to_key
    ['']
  end

  def persisted?
    false
  end

  def run
    return false unless @keywords

    RestClient.get("#{Cornerstore.root_url}/products/search?keywords=#{URI::encode(@keywords)}", Cornerstore.headers) do |response, request, result, &block|
      if response.code == 200
        data = ActiveSupport::JSON.decode(response)
        @scores   = data['scores']
        @products = Cornerstore::Product::Resource.new(nil, data['products'])
        return true
      end
    end
  end
end