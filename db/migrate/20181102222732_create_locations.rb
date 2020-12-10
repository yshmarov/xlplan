class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.belongs_to :tenant, index: true, foreign_key: true
      t.string :name, limit: 50, null: false

      t.string :country
      t.string :city
      t.string :zip
      t.string :address

      t.float :latitude
      t.float :longitude

      t.boolean :online_booking, default: true
      t.boolean :active, default: true

      t.integer :members_count, default: 0, null: false

      t.timestamps
    end
  end
end
