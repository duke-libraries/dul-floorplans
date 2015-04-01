require 'test_helper'
require 'pp'

class BuildingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "Load Perkins" do
    building = buildings(:perkins)
    assert_not_nil(building)
    puts
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
    @buildings = Building.all()
    assert_not_empty(@buildings, "buildings should not be empty")
  end
end
