class Building < ActiveRecord::Base
  cattr_accessor :image_size
  attr_accessor   :image_height
  attr_accessor   :image_width
  
  @@image_size = {
    'perkins' => { :width => '479', :height => '268' },
    'lilly' => { :width => '524', :height => '268' },
    'rubenstein' => { :width => '513', :height => '268' },
    'bostock' => { :width => '498', :height => '234' },
  }
  
  include    BuildingSize
  has_many   :floorplans, -> { order "label ASC" }
  
  # http://stackoverflow.com/questions/11636541/use-a-scope-by-default-on-a-rails-has-many-relationship
  has_many   :below_ground_floorplans, -> { below_ground }, class_name: "Floorplan"
  has_many   :above_ground_floorplans, -> { above_ground }, class_name: "Floorplan"
  
  after_initialize :init
  
  def init
    self.image_height = Building.image_size[self.name][:height]
    self.image_width =  Building.image_size[self.name][:width]
  end
end
