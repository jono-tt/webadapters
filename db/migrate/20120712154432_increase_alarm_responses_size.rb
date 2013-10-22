class IncreaseAlarmResponsesSize < ActiveRecord::Migration
  def up
    execute "ALTER TABLE alarms MODIFY responses MEDIUMTEXT"
  end

  def down
    execute "ALTER TABLE alarms MODIFY responses TEXT"
  end
end
