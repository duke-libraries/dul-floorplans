class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
      t.string :name
      t.integer :room_number, limit: 2
      t.string :label
      t.belongs_to :floorplan, index: true, foreign_key: true
      t.boolean :naming_opportunity
      t.boolean :nameable
      t.integer :dollar_amount
      t.boolean :pending_sale
      t.boolean :carrel

      t.timestamps null: false
    end
    add_index :rooms, :name
  end
end
