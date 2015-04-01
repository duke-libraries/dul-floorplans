class CreateFloorAreas < ActiveRecord::Migration
  def change
    create_table :floor_areas do |t|
      t.string :coord
      t.string :shape
      t.belongs_to :floorplan, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :floor_areas, :shape
  end
end
