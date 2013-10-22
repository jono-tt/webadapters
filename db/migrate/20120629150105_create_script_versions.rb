class CreateScriptVersions < ActiveRecord::Migration
  def change
    create_table :script_versions do |t|
      t.integer :version
      t.integer :api_method_id
      t.integer :user_id
      t.text :message
      t.text :script

      t.timestamps
    end
  end
end
