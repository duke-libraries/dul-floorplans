class ChangeDataTypeForFloorAreaCoord < ActiveRecord::Migration
  def change
    change_table :floor_areas do |t|
      t.change :coord, :string, limit: 750
    end
  end
end
