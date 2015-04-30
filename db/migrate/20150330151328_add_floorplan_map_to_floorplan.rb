class AddFloorplanMapToFloorplan < ActiveRecord::Migration
  def change
    add_reference :floorplans, :floorplan_map, index: true, foreign_key: true
  end
end
