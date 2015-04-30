class ChangeDataTypeForRoomAreaCoord < ActiveRecord::Migration
  def change
    change_table :room_areas do |t|
      t.change :coord, :string, limit: 750
    end
  end
end
