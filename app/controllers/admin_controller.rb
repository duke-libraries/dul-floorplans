class AdminController < ApplicationController
  #layout 'admin'
  before_filter :init
  
  def init
    add_breadcrumb 'Administrator', '/admin'
  end
  
  def index
    # admin#index
    # admin/index
    @perkins = Building.find_by(name: 'perkins')
  end
  
  protected
    def register_sidebar name, url = ''
      @admin_sidebars ||= []
      url = eval(url) if url =~ /_path|_url|@/
      @admin_sidebars << {:name => name, :path => url, :active => false}
    end
    
    def self.register_sidebar name, url, options = {}
      before_filter options do |controller|
        controller.send(:register_sidebar, name, url)
      end
    end

  register_sidebar 'Overview', 'admin_path'  
  register_sidebar 'Buildings', 'admin_buildings_path'
  register_sidebar 'Floorplans', 'admin_floorplans_path'
	register_sidebar 'Floorplan Maps', 'admin_floorplan_maps_path'
  register_sidebar 'Rooms', 'admin_rooms_path'
end
