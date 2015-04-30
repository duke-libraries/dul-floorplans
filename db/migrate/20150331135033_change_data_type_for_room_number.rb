class ChangeDataTypeForRoomNumber < ActiveRecord::Migration
  def change
    change_table :rooms do |t|
      t.change :room_number, :string
    end
  end
end
