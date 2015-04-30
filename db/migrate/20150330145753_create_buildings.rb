class CreateBuildings < ActiveRecord::Migration
  def change
    create_table :buildings do |t|
      t.string :name, null: false
      t.string :label, null: false
      t.string :sublabel
      t.boolean :active

      t.timestamps null: false
    end
    add_index :buildings, :name
  end
end
