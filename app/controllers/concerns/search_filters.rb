module SearchFilters
  extend ActiveSupport::Concern
  
  included do
    @area_shapes = [['Poly', 'poly'], ['Rect', 'rect']]
    attr_reader :filter_building_id, :filter_floorplan_id
  end
  
  def collect_room_search_filters
      
    @filter_building_id = params[:filter_building_id] || session[:current_building_id] || nil 
    if params.has_key? :filter_building_id
      if !params[:filter_building_id].eql? session[:current_building_id]
        session[:current_floorplan_id] = nil
      end
      session[:current_building_id] = params[:filter_building_id]
    end
    
    @filter_floorplan_id = params[:filter_floorplan_id] || session[:current_floorplan_id] || nil

    if params.has_key? :filter_floorplan_id
      session[:current_floorplan_id] = params[:filter_floorplan_id]
    end
    
  end
  
  def collect_floorplan_search_filters
    
  end
end