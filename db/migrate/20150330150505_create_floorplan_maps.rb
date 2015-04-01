class CreateFloorplanMaps < ActiveRecord::Migration
  def change
    create_table :floorplan_maps do |t|
      t.string :label
      t.string :image_url

      t.timestamps null: false
    end
    add_index :floorplan_maps, :label
  end
end
