class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.belongs_to :tenant, index: true, foreign_key: true
      t.string :name, :limit => 50, null: false
      t.string :tel, :limit => 144
      t.string :email, :limit => 144
      t.string :address, :limit => 255
      t.integer :balance, default: 0, null: false
      t.integer :status, default: 1, null: false

      t.timestamps
    end
  end
end
