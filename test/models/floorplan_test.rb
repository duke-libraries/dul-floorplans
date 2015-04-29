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
  
  test "I can filter (exclude) 'carrel' rooms from the rooms list" do
    floorplan = floorplans(:perkins_floor2_floorplan)
    rooms = floorplan.rooms
    rooms_filtered = rooms.where(carrel: false)
    assert_not_empty(rooms_filtered)
  end
  
  test "Grouping Floorplan rooms" do
    floorplan = floorplans(:perkins_floor2_floorplan)
    rooms = floorplan.rooms.select("name, dollar_amount, label, count(name) as name_count").group(:name).having("count(name) >= ?", 1)
    rooms.each do |r|
      puts r.name_count
    end
    #count = rooms.count(:name)
    #count.each do |k, v|
    #  puts "#{k} = #{v}"
    #end
  end
end
