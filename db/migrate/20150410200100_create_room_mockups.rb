class CreateRoomMockups < ActiveRecord::Migration
  def change
    create_table :room_mockups do |t|
      t.string :label
      t.string :image, limit: 750
      t.belongs_to :room, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
