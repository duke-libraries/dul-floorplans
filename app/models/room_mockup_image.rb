class RoomMockupImage < ActiveRecord::Base
  belongs_to :room
  belongs_to :room_mockup
end
