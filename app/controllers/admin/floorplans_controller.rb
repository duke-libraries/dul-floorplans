class Admin::FloorplansController < AdminController
  add_breadcrumb 'Floorplans', 'admin_floorplans_path'
  layout "colorbox", only: [:add_floor_area]
  
  def index
    # admin/floorplans
    #set_active_admin_sidebar 'Floorplan'
    @floorplans = Floorplan
      .joins(:building)
      .paginate(:page => params[:page], :per_page => 10)
      .all.order('buildings.label, label')
  end
  
  def edit
    # admin/floorplans/:id
    @floorplan = Floorplan.find(params[:id])
    @area_shapes = [['Poly', 'poly'], ['Rect', 'rect'], ['Circle', 'circle']]
    add_breadcrumb "%s - %s" % [@floorplan.building.label, @floorplan.label]
  end
  
  def new
    # admin/floorplans/new
    @floorplan = Floorplan.new
    @area_shapes = [['Poly', 'poly'], ['Rect', 'rect'], ['Circle', 'circle']]
    add_breadcrumb "New Floorplan"
  end
  
  def add_floor_area
    @floorplan = Floorplan.find(params[:floorplan_id])
    floor_area = FloorArea.new
    floor_area.coord = params[:coord]
    floor_area.shape = params[:shape]
    floor_area.floorplan = @floorplan
    
    if floor_area.save
      render template: 'admin/floorplans/_floorarea_row', :locals => {:floor_area => floor_area}
    else
      render json: ["An error occured while attempting to add this Floor Area."]
    end
  end
  
  private
    def floorplan_params
      params.require(:floorplan).permit(:label, :name, :sublabel)
    end
end