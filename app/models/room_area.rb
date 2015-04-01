class RoomArea < ActiveRecord::Base
  belongs_to :room
  
  scope :poly_areas, -> {
    where('shape = ?', 'poly')
  }
  
  scope :rect_areas, -> {
    where('shape = ?', 'rect')
  }
end
