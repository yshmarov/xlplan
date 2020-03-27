class AddThemeToTenant < ActiveRecord::Migration[5.2]
  def change
    add_column :tenants, :theme, :string, null: false, default: "classic"
  end
end
