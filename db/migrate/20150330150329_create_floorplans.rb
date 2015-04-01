class CreateFloorplans < ActiveRecord::Migration
  def change
    create_table :floorplans do |t|
      t.string :name
      t.string :label
      t.string :sublabel
      t.belongs_to :building, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :floorplans, :name
  end
end
