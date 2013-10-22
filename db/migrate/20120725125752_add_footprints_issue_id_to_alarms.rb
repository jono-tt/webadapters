class AddFootprintsIssueIdToAlarms < ActiveRecord::Migration
  def change
    add_column :alarms, :footprints_issue_id, :integer
  end
end
