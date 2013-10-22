class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :name
      t.string :url
      t.string :encoding, :default => "utf-8"
      t.string :user_agent
      t.timestamps
    end
  end
end
