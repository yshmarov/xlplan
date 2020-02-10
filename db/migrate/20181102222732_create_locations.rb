class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.belongs_to :tenant, index: true, foreign_key: true
      t.string :name, :limit => 50, null: false
      t.string :phone_number, :limit => 144
      t.string :email, :limit => 144
      t.string :country
      t.string :city
      t.string :zip
      t.string :address
      t.string :viber, :limit => 40
      t.string :telegram, :limit => 40
      t.string :whatsapp, :limit => 40

      t.boolean :online_booking, default: true
      t.boolean :active, default: true

      t.integer :locations, :members_count, :integer, default: 0, null: false

      t.timestamps
    end
  end
end