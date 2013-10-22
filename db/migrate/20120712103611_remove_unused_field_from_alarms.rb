class RemoveUnusedFieldFromAlarms < ActiveRecord::Migration
  def up
    remove_column :alarms, :site_id
    remove_column :alarms, :severity
  end

  def down
    add_column :alarms, :site_id, :integer
    add_column :alarms, :severity, :integer
  end
end
