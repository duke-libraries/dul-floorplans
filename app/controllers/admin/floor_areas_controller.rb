class Admin::FloorAreasController < AdminController
	
	def index
	end

	def edit
	end

	def create
		@floor_area = FloorArea.new(floor_area_params)

		if @floor_area.save
			if params.has_key? 'json'
				render json: ['Floor Area (%s) has been added' % @floor_area.id]
			else
				redirect_to @floor_area
			end
		else
			render 'new'
		end
	end

	def update
		@floor_area = FloorArea.find(params[:id])

		if @floor_area.update(floor_area_params)
			if params.has_key? 'json'
				render json: ['Floor Area (%s) has been updated successfully' % @floor_area.id]
			else
				redirect_to @floor_area
			end
		else
			render 'edit'
		end
	end

	private
		def floor_area_params
			params.require(:floor_area).permit(:coord, :shape)
		end
end
