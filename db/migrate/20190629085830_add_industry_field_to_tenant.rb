class AddIndustryFieldToTenant < ActiveRecord::Migration[5.2]
  def change
    add_column :tenants, :industry, :string, :limit => 144
  end
end
