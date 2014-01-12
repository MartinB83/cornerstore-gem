class Cornerstore::Image < Cornerstore::Model::Base
  attr_accessor :cover,
                :size,
                :format,
                :height,
                :width,
                :key


  alias content_type format
  alias file_size size

  # small, small_square, medium, medium_square, large
  def url(w = 600, h = 600, mode = 'crop')
    "http://res.cloudinary.com/hgzhd1stm/image/upload/c_#{mode},h_#{h},w_#{w}/#{self.key}"
  end

  class Resource < Cornerstore::Resource::Base
  end
end