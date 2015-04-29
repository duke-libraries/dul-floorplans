# app/controllers/concerns/image_carousel.rb
module ImageCarousel
  extend ActiveSupport::Concern
  
  def make_the_image_carousel(div_id)
    @carousel_items = []
    @carousel_div_id = div_id
    @carousel_classes = []
  end
end