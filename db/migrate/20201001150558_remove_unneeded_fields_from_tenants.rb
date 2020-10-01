class RemoveUnneededFieldsFromTenants < ActiveRecord::Migration[5.2]
  def change
    remove_column :tenants, :subdomain
  end
end
