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
    room = self.room
    floorplan = room.floorplan
    resized_image_size = floorplan.resized_image_size()

    scale_factor = resized_image_size[:scale_factor]
    
    coords = self.coord.split(',')
    coords.map! { |n| n = (n.to_i() * scale_factor).to_i() }
    return coords.join(',')
  end
end
