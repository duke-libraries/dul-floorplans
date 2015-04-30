class CreateRoomAreas < ActiveRecord::Migration
  def change
    create_table :room_areas do |t|
      t.string :coord
      t.string :shape
      t.belongs_to :room, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :room_areas, :shape
  end
end
