class TenantSubdomainCanBeNil < ActiveRecord::Migration[5.2]
  def change
    #change_column :tenants, :subdomain, :string
    remove_column :tenants, :subdomain
    add_column :tenants, :subdomain, :string
  end
end
