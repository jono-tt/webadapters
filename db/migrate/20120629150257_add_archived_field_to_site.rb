class AddArchivedFieldToSite < ActiveRecord::Migration
  def change
    add_column(:sites, :archived, :boolean, :default => false)
  end
end
