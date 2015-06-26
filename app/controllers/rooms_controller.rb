class RoomsController < ApplicationController
  include ImageCarousel
  
  def show
    @room = Room.find(params[:id])
    @room.floorplan.initialize_image_info
    
    # this line creates @carousel_items and @carousel_div_id
    make_the_image_carousel('carousel_%s' % @room.name)
    
    image_caption = @room.label.starts_with?('Study Carrel') ? 'Study Carrel' : @room.label
    active = true;
    @room.room_mockups.each do |mockup|
      item = {
        :image_url => mockup.image,
        :image_caption => image_caption,
        :image_alt => '',
      }
      if active
        item[:active] = true
        active = false
      end
      @carousel_items.push(item)
      logger.debug @carousel_items
      
      @carousel_classes.push('room_mockups_carousel')
    end
    @room_has_mockups = @room.room_mockups.size > 0
    render layout: 'colorbox'
  end
  
  #def show_room
  #  @room = Room.find(params[:id])
  #  @floorplan = @room.floorplan
  #  @thumbnail = @floorplan.thumbnail_image
  #  @json = {room: @room, floorplan: @floorplan, thumbnail: @thumbnail}
  #  render json: @json
  #end
end
