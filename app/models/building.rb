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
  has_many   :floorplans
  
  after_initialize :init
  
  def init
    self.image_height = Building.image_size[self.name][:height]
    self.image_width =  Building.image_size[self.name][:width]
  end
end
