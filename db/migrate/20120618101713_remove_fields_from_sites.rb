class RemoveFieldsFromSites < ActiveRecord::Migration
  def up
    remove_column :sites, :encoding
    remove_column :sites, :user_agent
    remove_column :sites, :url
  end

  def down
    add_column :sites, :encoding, :string, :default => 'utf-8'
    add_column :sites, :user_agent, :string
    add_column :sites, :url, :string
  end
end
