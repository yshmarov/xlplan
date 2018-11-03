class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.string :name, :limit => 144, null: false
      t.string :tel, :limit => 144
      t.string :email, :limit => 144
      t.string :address, :limit => 255
      t.integer :balance, default: 0, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end
    add_index :locations, :name, unique: true
  end
end
