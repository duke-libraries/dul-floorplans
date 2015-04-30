class CreateRoomMockupImages < ActiveRecord::Migration
  def change
    create_table :room_mockup_images do |t|
      t.belongs_to :room, index: true, foreign_key: true
      t.belongs_to :room_mockup, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
