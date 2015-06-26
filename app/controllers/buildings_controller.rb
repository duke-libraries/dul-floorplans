class BuildingsController < ApplicationController
	def index
		@buildings = Building.all
	end

  # load the appropriate building, then
  # find the "First Floor" record, and finally
  # redirect to the view of that model object.
	def show
		building = Building.find(params[:id])
		
		# set the default floor, then redirect to the Floorplan controller 
		default_floorplan = building.floorplans.where('label LIKE ?', 'Floor 1%').first
		redirect_to default_floorplan
	end
end
