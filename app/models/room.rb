class Room < ActiveRecord::Base
  belongs_to  :floorplan
  has_many    :room_areas
end
