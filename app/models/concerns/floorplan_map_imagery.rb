# app/models/concerns/floorplan_map_imagery.rb
module FloorplanMapImagery
  extend ActiveSupport::Concern

  def resized_map_image_metadata(floor_name, rooms, full_size_image, opts = {})
    defaults = {
      :scale_factor => 100.0,
      :write => true,
      :clobber => false,
      :image_quality => 50,
      :map_name_snippet => '_room_area_mask_opacity-',
      :render_as_nameable => true,
    }
    opts = defaults.merge(opts)
    
    mask_opacity = Rails.application.config.floorplan.map_opacity
    
    floorplan_path = 'floorplans/floorplanmap/' + floor_name + opts[:map_name_snippet] + mask_opacity.to_s() + '.png'
    rootpath = Rails.root.join 'app/assets/media/', floorplan_path
    resized_image_path = rootpath.to_s()    

    if File.exists? resized_image_path and !(opts[:clobber] and opts[:write])
      # return stats
      resized_image = Magick::Image::ping(rootpath.to_s()).first
    else
      resized_image = full_size_image.dup
      rooms.each do |room|
        if opts[:render_as_nameable]
          fill_color = Rails.application.config.floorplan.nameable_room_color
          if !room.nameable?
            fill_color = Rails.application.config.floorplan.not_nameable_room_color
          end
          if room.pending_sale?
            fill_color = Rails.application.config.floorplan.pending_sale_room_color
          end
        else
          fill_color = 'red'
        end
        
        default_opacity = opts[:render_as_nameable] ? Rails.application.config.floorplan.room_color_opacity : 1.0
        
        room.room_areas.each do |room_area|
          # the coord(inate)s are a string of numbers separated by ","
          # split 'em and then convert each element into a numeric value
          coords = room_area.coord.split(',')
          coords.each { |n| n = n.to_i() }
          
          # create a canvas and draw away!
          gc = Magick::Draw.new
          gc.fill_rule('nonzero')
          gc.fill(fill_color)
          gc.fill_opacity(default_opacity)
          
          if room_area.shape == 'rect'
            gc.rectangle(*coords)
          else
            gc.polygon(*coords)
          end
          gc.draw(resized_image)
        end      
      end
      resized_image.scale!(opts[:scale_factor])
      resized_image.write(resized_image_path) {
        self.quality = opts[:image_quality]
      } unless !opts[:write] 
    end   
    
    return {
      :image_url => floorplan_path,
      :width => resized_image.columns,
      :height => resized_image.rows,
    }
  end
end