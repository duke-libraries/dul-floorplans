require 'test_helper'

class RoomTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "aggregate room function" do
    room = Room.aggregate_room('perkins_floor1_floorplan', true, 'Group Study Room', nil)
    puts room.inspect
  end
  
  test "room_mockups are loaded" do
    room = Room.find_by id: 1015;
    mockups = room.room_mockups
    puts mockups.inspect
    assert_not_empty(mockups, "Room #id = 1015 should have room mockups")
  end
end
