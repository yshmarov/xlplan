class AddDescriptionToTenants < ActiveRecord::Migration[5.2]
  def change
    add_column :tenants, :description, :text, :limit => 500
  end
end
