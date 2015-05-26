class Admin::RoomsController < AdminController
  add_breadcrumb 'Rooms', 'admin_rooms_path'
  layout "colorbox", only: [:add_floor_area]
  
  def index
    # admin/floorplans
    #set_active_admin_sidebar 'Floorplan'
    @rooms = Room
      .joins(:floorplan)
      .paginate(:page => params[:page], :per_page => 25)
      .all.order('floorplans.label, label')
  end
  
  def new
    @room = Room.new
    add_breadcrumb "New Room"
  end
  
  def edit
    # admin/floorplans/:id
    @room = Room.find(params[:id])
    @area_shapes = [['Poly', 'poly'], ['Rect', 'rect'], ['Circle', 'circle']]
    add_breadcrumb "%s - %s" % [@room.floorplan.label, @room.label]
  end
  
  private
    def room_params
      params.require(:room).permit(:label, :name)
    end
end