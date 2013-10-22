class AddDfartToSite < ActiveRecord::Migration
  def change
    add_column(:api_methods, :draft, :text)
  end
end
