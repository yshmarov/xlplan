class AddLogoAndWebsiteToTenants < ActiveRecord::Migration[5.2]
  def change
    add_column :tenants, :logo, :string, :limit => 500
    add_column :tenants, :website, :string, :limit => 500
  end
end
