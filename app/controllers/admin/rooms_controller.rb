class Admin::RoomsController < AdminController
  add_breadcrumb 'Rooms', 'admin_rooms_path'
  layout "colorbox", only: [:add_floor_area]
  include SearchFilters
  
  def index
    # admin/floorplans
    #set_active_admin_sidebar 'Floorplan'
    @rooms = Room
      .joins(floorplan: :building)
      .paginate(:page => params[:page], :per_page => 20)
      .all.order('buildings.label, floorplans.label, label')
      
    collect_room_search_filters
    
    if !filter_building_id.nil?
      @rooms = @rooms.where('floorplans.building_id = ?', filter_building_id)
    end
    if !filter_floorplan_id.nil? and !filter_floorplan_id.empty?
      @rooms = @rooms.where('floorplans.id = ?', filter_floorplan_id)
    end
    
    @floorplans = Floorplan.select(:label, :id).where('floorplans.building_id = ?', filter_building_id).map { 
      |floorplan| [floorplan.label, floorplan.id]
    }
    
    @current_floorplan_id = session[:current_floorplan_id]
    @current_building_id = session[:current_building_id]
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
  
  def create
    @room = Room.new(room_params)
    
    if @room.save
      redirect_to edit_admin_room_url(@room)
    else
      render 'new'
    end
  end
  
  def update
    @room = Room.find(params[:id])
    
    if @room.update(room_params)
      redirect_to edit_admin_room_url(@room)
    else
      render 'edit'
    end
  end
  
  def floorplan_filter_options
    floorplans = []
    if params.has_key? :building_id
      floorplans = Floorplan.select(:label, :id).where('floorplans.building_id = ?', params[:building_id]).map { 
        |floorplan| [floorplan.label, floorplan.id]
      }
    end
    floorplans.unshift ['Filter by floor...', '']
    render json: floorplans   
  end
  
  private
    def room_params
      params.require(:room).permit(:label, :name, :naming_opportunity, :dollar_amount, :building_id, :room_number, :carrel, :pending_sale)
    end
end
