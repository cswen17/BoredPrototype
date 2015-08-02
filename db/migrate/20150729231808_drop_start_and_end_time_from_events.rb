class DropStartAndEndTimeFromEvents < ActiveRecord::Migration
  def up
    remove_column :events, :start_time, :string
    remove_column :events, :end_time, :string
  end

  def down
    add_column :events, :start_time, :string
    add_column :events, :end_time, :string
  end
end
