require 'test_helper'
require 'pp'

class BuildingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "Load Perkins" do
    building = buildings(:perkins)
    assert_not_nil(building)
    puts ""
    puts building.image_height
    assert_not_nil(building.image_height)
  end
  
  test "Load Bostock with Floorplans" do
    bostock = buildings(:bostock)
    assert_not_nil(bostock)
    floorplans = bostock.floorplans
    assert_not_empty(floorplans, "Bostock should have floorplans")
    #p floorplans unless floorplans.empty?
  end
  
  test "Load all buildings" do
    buildings = Building.all()
    assert_not_empty(buildings, "buildings should not be empty")
  end
  
  test "Load Perkins floors, sorted" do
    puts ""
    perkins = buildings(:perkins)
    floorplans = perkins.floorplans;
    floorplans.each do |floorplan|
      puts floorplan.label
    end
    
    reversed = floorplans.reverse()
    reversed.each do |floorplan|
      puts floorplan.label
    end
    lower_levels = floorplans.where('label LIKE ?', 'Lower%')
    assert_nil(lower_levels)
  end
  
  test "Load Perkins Lower Level Floors" do
    puts
    perkins = buildings(:perkins)
    floorplans = perkins.above_ground_floorplans
    floorplans = floorplans.reverse()
    puts
    puts "*** ABOVE GROUND FLOORS ***"
    floorplans.each do |floorplan|
      puts floorplan.label
    end
    assert_not_empty(floorplans, "Lower Level floorplans should not be empty!")
    floor_array = floorplans.to_a()
    p floor_array
  end
end
