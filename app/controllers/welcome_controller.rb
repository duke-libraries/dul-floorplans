class WelcomeController < ApplicationController
	caches_page			:public
	caches_action		:index

  def index
    @buildings = Building.all()
    
    @floorplan_list = {}
    @buildings.each do |building|
      above_ground = building.above_ground_floorplans.reverse().to_a()
      below_ground = building.below_ground_floorplans.to_a()
      @floorplan_list[building.name] = above_ground + below_ground
    end
  end
end
