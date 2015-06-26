# app/controllers/concerns/building_list.rb
module BuildingList
  extend ActiveSupport::Concern
  
  included do
    attr_reader :building_list
  end
  
  def build_building_list(sort_order='lowest')
    buildings = Building.all()
    @building_list = {}
    
    buildings.each do |building|
      floorplans_above_ground = building.above_ground_floorplans
      floorplans_below_ground = building.below_ground_floorplans
      
      building_room_list = nil
      if sort_order.eql? 'lowest'
        building_room_list = floorplans_below_ground.reverse().to_a() + floorplans_above_ground
      else
        building_room_list = floorplans_above_ground.reverse().to_a() + floorplans_below_ground       
      end
      @building_list[building.name] = {:label => building.label, :room_list => building_room_list, :id => building.id}
    end
    return @building_list
  end
end
