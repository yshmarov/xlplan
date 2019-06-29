class ChangeTenantIndustryDefault < ActiveRecord::Migration[5.2]
  def change
    remove_column :tenants, :industry, :string
    add_column :tenants, :industry, :string, limit: 144, default: "other", null: false
  end
end
