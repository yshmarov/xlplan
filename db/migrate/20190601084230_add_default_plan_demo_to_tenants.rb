class AddDefaultPlanDemoToTenants < ActiveRecord::Migration[5.2]
  def change
   change_column :tenants, :plan, :string, :limit => 40, null: false, default: "demo"
  end
end
