require 'test_helper'

class FloorplanTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "load perkins lower level 1 plan" do
    floorplan = floorplans(:perkins_lower_level_1)
    puts floorplan.name
    assert_not_nil(floorplan)
  end
  
  test "load perkins lower level 1 and associated building" do
    floorplan = floorplans(:perkins_lower_level_1)
    building = floorplan.building
    assert_not_nil(building)
    puts building.name unless building.nil?
  end
end
