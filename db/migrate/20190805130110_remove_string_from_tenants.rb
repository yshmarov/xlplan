class RemoveStringFromTenants < ActiveRecord::Migration[5.2]
  def change
    remove_column :tenants, :string
  end
end
