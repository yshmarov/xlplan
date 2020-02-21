class CreateTenants < ActiveRecord::Migration[5.2]
  def change
    create_table :tenants do |t|
      t.references :tenant, foreign_key: true
      t.string :name, :limit => 40, null: false
      t.string :subdomain
      t.string :plan, :limit => 40, null: false, default: "demo"
      t.string :default_currency, :limit => 3, null: false, default: "usd"
      t.string :locale, :limit => 2, null: false, default: 'en'
      t.string :industry, :limit => 144, default: "other", null: false
      t.string :website, :limit => 500
      t.string :description, :limit => 500
      t.string :instagram, :limit => 40
      t.string :time_zone, default: "UTC"
      t.boolean :online_booking, default: false

      t.timestamps
    end
    add_index :tenants, :name
    add_index :tenants, :subdomain
    add_index :tenants, :plan
    add_index :tenants, :default_currency
    add_index :tenants, :locale
  end
end