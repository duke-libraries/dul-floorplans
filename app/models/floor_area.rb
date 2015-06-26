class FloorArea < ActiveRecord::Base
  validates :coord, presence: true
  validates :shape, presence: true
  
  belongs_to :floorplan
end
