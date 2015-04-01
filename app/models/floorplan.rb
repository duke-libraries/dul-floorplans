class Floorplan < ActiveRecord::Base
  belongs_to :building
  belongs_to :floorplan_map
  has_many   :rooms, dependent: :destroy
  
  scope :in_building, -> building {
    joins(:building).
    where('buildings.name = ?', building)
  }
end
