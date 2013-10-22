class CreateAlarms < ActiveRecord::Migration
  def change
    create_table :alarms do |t|
      t.integer :site_id
      t.integer :api_method_id
      t.text :message
      t.integer :severity
      t.text :responses

      t.timestamps
    end
  end
end
