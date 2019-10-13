class AddInstagramToTenants < ActiveRecord::Migration[5.2]
  def change
    add_column :tenants, :instagram, :string, :limit => 40
  end
end
