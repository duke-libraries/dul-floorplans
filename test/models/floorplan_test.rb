require 'test_helper'

class FloorplanTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "load perkins lower level 1 plan" do
    floorplan = floorplans(:perkins_floor1_floorplan)
    puts floorplan.name
    assert_not_nil(floorplan)
  end
  
  test "load perkins lower level 1 and associated building" do
    floorplan = floorplans(:perkins_floor1_floorplan)
    building = floorplan.building
    assert_not_nil(building)
    puts building.name unless building.nil?
  end
  
  test "perkins floor has area records" do
    floorplan = floorplans(:perkins_floor1_floorplan)
    floor_areas = floorplan.floor_areas
    assert_not_nil(floor_areas)
  end
end
