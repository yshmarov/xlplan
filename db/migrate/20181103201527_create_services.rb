class CreateServices < ActiveRecord::Migration[5.2]
  def change
    create_table :services do |t|
      t.references :tenant, foreign_key: true
      t.string :name, :limit => 144, null: false
      t.string :description, :limit => 255
      t.integer :duration, default: 30, null: false
      t.integer :employee_percent, default: 50, null: false
      t.integer :quantity, default: 1, null: false
      t.integer :status, default: 1, null: false
      t.integer :client_price, default: 0, null: false
      t.integer :employee_price, default: 0, null: false
      t.belongs_to :service_category, foreign_key: true

      t.timestamps
    end
    add_index :services, :name, unique: true
  end
end
