class AddSubdomainToTenants < ActiveRecord::Migration[5.2]
  def change
    add_column :tenants, :subdomain, :string, :limit => 20
  end
end
