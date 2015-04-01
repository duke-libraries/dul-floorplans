require 'test_helper'

class RoomAreaTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "poly filter works" do
    poly_areas = RoomArea.poly_areas()
    assert_empty(poly_areas, "poly_areas has content")
  end
  test "rect filter works" do
    rect_areas = RoomArea.rect_areas()
    assert_empty(rect_areas, "polrect_areas_areas has content")
  end
end
