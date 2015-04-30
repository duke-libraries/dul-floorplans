class RoomMockup < ActiveRecord::Base
  has_many :room_mockup_images
  has_one :room, through: :room_mockup_images
end
