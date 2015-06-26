class FloorplansController < ApplicationController
  include BuildingList
  include RoomsExtraSauce
  
  #caches_action :show, :layout => false, :expires_in => 1.hour
  caches_action :show, :show_by_name
  
  def view
  end
  
  def show_by_name
      
  end
  
  def show
    title = nil
    
    # TODO building list
    @floorplan_rooms_dict = {}
    @floorplan_building = ''
    
    rooms_aggregate = RoomsAggregate.new :named_spaces => {:label => 'Named Spaces'}, 
      :available_spaces_5000 => {:label => '$5,000 - $99,999', :min => 5000, :max => 99999},
      :available_spaces_100000 => {:label => '$100,000 - $500,000', :min => 100000, :max => 500000},
      :available_spaces_500000 => {:label => 'More than $500,000', :min => 500001}
    
    @floorplan = nil
    if params.has_key? :id
      @floorplan = Floorplan.find(params[:id])
    else
      @floorplan = Floorplan.find_by(name: params[:floorplan_name])
    end
    
    # initialize the image 'magick'
    @floorplan.initialize_image_info
    
    @building_list = build_building_list()

    # I believe it's time to re-think how to organize the 
    # list of rooms.
    # a) simply get all of them
    # b) parse through the entire list and handle the 
    #    cases where a room label spans multiple room areas
    @floorplan.rooms.where(naming_opportunity: true).order(:dollar_amount, :label).each do |room|
      rooms_aggregate.process_room(room)
    end
    @room_labels = rooms_aggregate.room_labels
    
    @named_spaces = @room_labels.select {|label, d| d[:category] == :named_spaces}.sort_by { |label, d| label }
    @available_5000 = @room_labels.select {|label, d| d[:category] == :available_spaces_5000}
    @available_100000 = @room_labels.select {|label, d| d[:category] == :available_spaces_100000}
    @available_500000 = @room_labels.select {|label, d| d[:category] == :available_spaces_500000}

    ##add_breadcrumb @floorplan.building.label, '#'
    add_breadcrumb "%s - %s" % [@floorplan.building.label, @floorplan.label]
    @floorplan_building = @floorplan.building.label
    @building_floorplans = @floorplan.building.floorplans
    @floorplan_default_image_info = @floorplan.default_image_info

  end
end
