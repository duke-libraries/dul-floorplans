class Floorplan < ActiveRecord::Base
  require 'rmagick'
  include FloorplanMapImagery
  
  belongs_to :building
  belongs_to :floorplan_map
  has_many   :rooms, dependent: :destroy
  has_many   :floor_areas, dependent: :destroy
  
  attr_accessor :full_size_image
  
  scope :in_building, -> building {
    joins(:building).
    where('buildings.name = ?', building)
  }
  
  after_initialize :init
  def init
    # tip from:
    # http://stackoverflow.com/questions/16266933/rmagick-how-do-i-find-out-the-pixel-dimension-of-an-image
    image_path = Rails.root.join 'app/assets/media/', self.floorplan_map.image_url
    @full_size_image = Magick::Image::read(image_path.to_s()).first
  end
  
  @@STUDY_CARRELS_ID_SUBSTRING = 'study_carrels'
  
  # http://stackoverflow.com/questions/11636541/use-a-scope-by-default-on-a-rails-has-many-relationship
  scope :below_ground, -> { where('label LIKE ?', 'Lower%').order('label ASC') }
  scope :above_ground, -> { where('label LIKE ?', 'Floor%').order('label ASC') }
  
  def Floorplan.STUDY_CARRELS_ID_SUBSTRING
    return @@STUDY_CARRELS_ID_SUBSTRING
  end
  
  def default_size
    return 'map_image_%s_max_width' % Rails.application.config.floorplan.default_map_max_width.to_s()
  end
  
  def default_image_size
    max_width_divisor = @full_size_image.columns.to_i() / Rails.application.config.floorplan.default_map_max_width.to_i()
    return self.resized_image(divisor = max_width_divisor)
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
    resized_image_width = (@full_size_image.columns / divisor).floor
    resized_image_height = (@full_size_image.rows / divisor).floor    
    
    return {
      :scale_factor => resized_image_width.to_f() / @full_size_image.columns.to_f(),
      :width => resized_image_width,
      :height => resized_image_height,
    }
  end
  
  def resized_image(divisor = 100, mask_opacity = 2)
    floorplan_path = 'floorplans/floorplanmap/' + self.name + '_room_area_mask_opacity-' + mask_opacity.to_s() + '.png'
    rootpath = Rails.root.join 'app/assets/media/', floorplan_path
    resized_image_path = rootpath.to_s()    
    
    if File.exists? resized_image_path
      # return stats
      resized_image = Magick::Image::ping(rootpath.to_s()).first
    else
      scale_factor = (Rails.application.config.floorplan.default_map_max_width.to_f() / @full_size_image.columns.to_f())
      
      resized_image_width = (@full_size_image.columns / divisor).floor
      resized_image_height = (@full_size_image.rows / divisor).floor
      
      resized_image = @full_size_image.dup
      self.rooms.each do |room|
        fill_color = Rails.application.config.floorplan.nameable_room_color
        if !room.nameable?
          fill_color = Rails.application.config.floorplan.not_nameable_room_color
        end
        if room.pending_sale?
          fill_color = Rails.application.config.floorplan.pending_sale_room_color
        end
        
        room.room_areas.each do |room_area|
          # the coord(inate)s are a string of numbers separated by ","
          # split 'em and then convert each element into a numeric value
          coords = room_area.coord.split(',')
          coords.each { |n| n = n.to_i() }
          
          # create a canvas and draw away!
          gc = Magick::Draw.new
          gc.fill_rule('nonzero')
          gc.fill(fill_color)
          gc.fill_opacity(Rails.application.config.floorplan.room_color_opacity)
          
          if room_area.shape == 'rect'
            gc.rectangle(*coords)
          else
            gc.polygon(*coords)
          end
          gc.draw(resized_image)
        end      
      end
      resized_image.resize!(resized_image_width, resized_image_height)
      resized_image.write(resized_image_path) {
        self.quality = 50
      }    
    end
    
    return {
      :image_url => floorplan_path,
      :width => resized_image.columns,
      :height => resized_image.rows,
    }
    
  end
end
