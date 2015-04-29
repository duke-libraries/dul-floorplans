require 'test_helper'
require 'rmagick'

class FloorplansControllerTest < ActionController::TestCase
  test "should get view" do
    get :view
    assert_response :success
  end
  
  test "should get show" do
    get(:show, {'id' => 3})
    assert_response :success
  end
  
  test "should open and re-save 32-bit PNG file" do
    image_name = 'Bostock_Floor_1_complete_4-14_1.png.399x353_q85_room_area_mask_opacity-0.21_room_areas-strawberryShortcake.png'
    image_path = Rails.root.join 'app/assets/media/floorplans/floorplanmap/', image_name
    my_image = Magick::Image::read(image_path.to_s()).first
    
    new_location = Rails.root.join 'app/assets/images/', image_name
    my_image.write(new_location)
  end

end
