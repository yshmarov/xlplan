class RemoveLogoFromTenants < ActiveRecord::Migration[5.2]
  def change
    remove_column :tenants, :logo
  end
end
