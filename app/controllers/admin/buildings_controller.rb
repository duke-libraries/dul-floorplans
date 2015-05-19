class Admin::BuildingsController < AdminController
  add_breadcrumb 'Buildings', 'admin_buildings_path'
  
  def new
    @building = Building.new
  end
  
  def create
    @building = Building.new(building_params)
  end
  
  def index
    # admin/floorplans
    #set_active_admin_sidebar 'Buildings'
    @buildings = Building.all.order('label')
  end
  
  def edit
    # admin/floorplans/:id
    @building = Building.find(params[:id])
    add_breadcrumb @building.label
  end
  
  private
    def building_params
      params.require(:building).permit(:label, :name, :sublabel)
    end
end