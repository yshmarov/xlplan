class CreateTenants < ActiveRecord::Migration[5.2]
  def change
    create_table :tenants do |t|
      t.references :tenant, foreign_key: true
      t.string :name, :limit => 20, null: false
      t.string :plan, :limit => 20, null: false
      #t.string :industry, :limit => 40, null: false
      #t.string :category, :limit => 40, null: false
      #t.string :default_time_zone, null: false
      #t.string :country, null: false
      #t.string :city, null: false
      #t.string :logo
      #= f.select :industry, options_for_select(TenantIndustry.options, params[:tenant_industry]), {}, required: true, class: 'selectize'

      t.timestamps
    end
    add_index :tenants, :name
  end
end
