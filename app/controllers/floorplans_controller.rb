class FloorplansController < ApplicationController
  include BuildingList
  
  caches_action :show
  
  def view
  end
  
  def show
    title = nil
    
    # TODO building list
    #@building_list = []
    @floorplan_rooms_dict = {}
    @floorplan_building = ''
    
    # TODO consider placing contents of block in a concern
    begin
      @floorplan = Floorplan.find(params[:id])
      @building_list = build_building_list()

      all_floorplan_rooms = @floorplan.rooms.where(naming_opportunity: true)
      floorplan_rooms = []

      floorplan_aggregate_room_names = []

      rooms_non_carrel_nameable = all_floorplan_rooms.where(carrel: false, nameable: true) 
      aggregate_room_queryset = rooms_non_carrel_nameable
        .select("floorplan_id, id, name, dollar_amount, label, count(name) as name_count")
        .group(:name).having("count(name) >= ?", 1).order(label: :asc)

      aggregate_room_labels_list = []

      aggregate_room_queryset.map do |r|
        aggregate_room_labels_list.push({room: r.label, nameable: true, dollar_amount: r.dollar_amount})
      end
      
      aggregate_room_labels_list.push(
        {room: Rails.application.config.floorplan.study_carrels_id_substring, nameable: true, dollar_amount: nil},
        {room: Rails.application.config.floorplan.study_carrels_id_substring, nameable: false, dollar_amount: nil}
       )
      puts aggregate_room_labels_list.inspect
      
      aggregate_room_labels_list.each do |d|
        room_aggregate = Room.aggregate_room(@floorplan.name, d[:nameable], d[:room], d[:dollar_amount])
        if room_aggregate
          floorplan_rooms.push(room_aggregate)
          if d.has_key? :dollar_amount and !d[:dollar_amount].nil?
            all_floorplan_rooms.where(label: d[:room], dollar_amount: d[:dollar_amount]).each do |r|
              floorplan_aggregate_room_names.push(r.name)
            end
          end
        end
      end
  
      rooms_non_carrel_non_nameable = all_floorplan_rooms.where(carrel: false, nameable: false).order(label: :asc)
      rooms_non_carrel_non_nameable.each do |r|
        non_nameable_room_proxy = Room.find_by name: r.name
        if !non_nameable_room_proxy.nil?
           non_nameable_room_proxy.dollar_amount = nil
        end
        floorplan_rooms.push(non_nameable_room_proxy)
      end 
      
      floorplan_rooms.concat(
        all_floorplan_rooms
          .where(carrel: false, nameable: true)
          .where('name not in (?)', floorplan_aggregate_room_names)
      )
      floorplan_rooms.sort_by(&:label)  
      
      @floorplan_rooms_dict = {
        'Previously-named spaces' => [],
        '$5,000 - $100,000' => [],
        '$100,000 - $500,000' => [],
        'More than $500,000' => [],
      }

      floorplan_rooms.each do |r|
        if r.dollar_amount.nil? or r.dollar_amount < 1
          @floorplan_rooms_dict['Previously-named spaces'].push(r)
        elsif r.dollar_amount < 100000
          @floorplan_rooms_dict['$5,000 - $100,000'].push(r)
        elsif r.dollar_amount < 500000
          @floorplan_rooms_dict['$100,000 - $500,000'].push(r)
        else
          @floorplan_rooms_dict['More than $500,000'].push(r)
        end   
      end
      logger.debug @floorplan_rooms_dict.inspect
      logger.debug "================================================="
      @floorplan_rooms_dict['Previously-named spaces'].sort_by{ |e| e.label }
      @floorplan_building = '%s Library' % [@floorplan.building.label]
      @building_floorplans = @floorplan.building.floorplans
    end
  end
end
