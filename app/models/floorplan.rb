class Floorplan < ActiveRecord::Base
  require 'rmagick'
  include FloorplanMapImagery
  
  belongs_to :building
  belongs_to :floorplan_map
  has_many   :rooms, dependent: :destroy
  has_many   :floor_areas, dependent: :destroy
  
  attr_accessor :full_size_image
  attr_reader   :default_image_info
  
  scope :in_building, -> building {
    joins(:building).
    where('buildings.name = ?', building)
  }
  
  after_initialize :init
  def init
  end
  
  @@STUDY_CARRELS_ID_SUBSTRING = 'study_carrels'
  
  # http://stackoverflow.com/questions/11636541/use-a-scope-by-default-on-a-rails-has-many-relationship
  scope :below_ground, -> { where('label LIKE ?', 'Lower%').order('label ASC') }
  scope :above_ground, -> { where('label LIKE ?', 'Floor%').order('label ASC') }
  
  def Floorplan.STUDY_CARRELS_ID_SUBSTRING
    return @@STUDY_CARRELS_ID_SUBSTRING
  end
  
  def initialize_image_info
    # tip from:
    # http://stackoverflow.com/questions/16266933/rmagick-how-do-i-find-out-the-pixel-dimension-of-an-image
    @default_image_info = nil
    if !self.floorplan_map.nil?
      image_path = Rails.root.join 'app/assets/media/', self.floorplan_map.image_url
      @full_size_image = Magick::Image::read(image_path.to_s()).first
      @default_image_info = self.default_image(highlighted_rooms: [], render_as_nameable: true)
    end
  end
  
  def default_size
    return 'map_image_%s_max_width' % Rails.application.config.floorplan.default_map_max_width.to_s()
  end
  
  def default_image_size
    max_width_divisor = @full_size_image.columns.to_i() / Rails.application.config.floorplan.default_map_max_width.to_i()
    return self.resized_image(divisor = max_width_divisor)
  end
  
  def default_image(opts = {})
    defaults = {
      :highlighted_rooms => [],
      :render_as_nameable => true,
    }
    opts = defaults.merge(opts)  
    
    # scale the full size image to height = 100px
    if opts[:highlighted_rooms].empty?
      opts[:highlighted_rooms] = self.rooms.where(naming_opportunity: true)
    end
    scale_factor = Rails.application.config.floorplan.default_map_max_width.to_f() / @full_size_image.columns.to_f()
    rz = resized_map_image_metadata self.name, opts[:highlighted_rooms], @full_size_image,
        render_as_nameable: opts[:render_as_nameable], scale_factor: scale_factor, write: true, clobber: false
    
    return rz
  end
  
  def thumbnail_image(opts = {})
    defaults = {
      :highlighted_rooms => [],
      :render_as_nameable => true,
    }
    opts = defaults.merge(opts)
    
    # scale the full size image to height = 100px
    if opts[:highlighted_rooms].empty?
      opts[:highlighted_rooms] = self.rooms
    end
    scale_factor = Rails.application.config.floorplan.thumbnail_max_height.to_f() / @full_size_image.rows.to_f()
    rz = resized_map_image_metadata self.name, opts[:highlighted_rooms], @full_size_image,
        render_as_nameable: opts[:render_as_nameable], scale_factor: scale_factor, write: true, clobber: true, map_name_snippet: '_thumbnail_'

    return rz
  end
  
  def resized_image_size
    divisor = @full_size_image.columns.to_i() / Rails.application.config.floorplan.default_map_max_width.to_i()
    scale_factor = Rails.application.config.floorplan.default_map_max_width.to_f() / @full_size_image.columns.to_f()
    resized_image_width = (@full_size_image.columns / divisor).floor
    resized_image_height = (@full_size_image.rows / divisor).floor    
    
    return {
      :scale_factor => resized_image_width.to_f() / @full_size_image.columns.to_f(),
      :width => resized_image_width,
      :height => resized_image_height,
    }
  end
    
  def adjusted_roomarea_coordinates(coord)
    scale_factor = @default_image_info[:scale_factor]
    
    coords = coord.split(',')
    coords.map! { |n| n = (n.to_i() * scale_factor).to_i() }
    return coords.join(',')
  end
end
