class RoomArea < ActiveRecord::Base
  belongs_to :room
  
  scope :poly_areas, -> {
    where('shape = ?', 'poly')
  }
  
  scope :rect_areas, -> {
    where('shape = ?', 'rect')
  }
  
  # Determine adjust map <area> coordinates for this room
  # based on scale of resized parent "floor" image
  def adjusted_coordinates(adjustment_method="default")
    return room.floorplan.adjusted_roomarea_coordinates(self.coord)
  end
end
