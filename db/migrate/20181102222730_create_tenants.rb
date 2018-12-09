class CreateTenants < ActiveRecord::Migration[5.2]
  def change
    create_table :tenants do |t|
      t.references :tenant, foreign_key: true
      t.string :name, :limit => 50, null: false
      t.string :plan, :limit => 50, null: false

      t.timestamps
    end
    add_index :tenants, :name
  end
end
