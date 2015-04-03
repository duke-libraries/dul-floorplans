class Floorplan < ActiveRecord::Base
  belongs_to :building
  belongs_to :floorplan_map
  has_many   :rooms, dependent: :destroy
  has_many   :floor_areas, dependent: :destroy
  
  scope :in_building, -> building {
    joins(:building).
    where('buildings.name = ?', building)
  }
  
  # http://stackoverflow.com/questions/11636541/use-a-scope-by-default-on-a-rails-has-many-relationship
  scope :below_ground, -> { where('label LIKE ?', 'Lower%').order('label ASC') }
  scope :above_ground, -> { where('label LIKE ?', 'Floor%').order('label ASC') }
end
