class CreateApiMethods < ActiveRecord::Migration
  def change
    create_table :api_methods do |t|
      t.integer :site_id
      t.text :script
      t.string :name

      t.timestamps
    end
  end
end
