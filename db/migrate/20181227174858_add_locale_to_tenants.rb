class AddLocaleToTenants < ActiveRecord::Migration[5.2]
  def change
    add_column :tenants, :locale, :string, default: 'en', null: false
  end
end
