class CreateTenants < ActiveRecord::Migration[5.2]
  def change
    create_table :tenants do |t|
      t.references :tenant, foreign_key: true
      t.string :name, :limit => 40, null: false
      t.string :plan, :limit => 40, null: false
      t.string :industry, :limit => 60, null: false
      t.string :default_currency, :limit => 40, null: false, default: "usd"
      #t.string :default_language, :limit => 40, null: false
      #t.string :default_time_zone, null: false
      #t.string :country, null: false
      #t.string :city, null: false
      #t.string :logo
      #t.string :default_working_hours

      t.timestamps
    end
    add_index :tenants, :name
  end
end