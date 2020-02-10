class CreateMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :members do |t|
      t.belongs_to :tenant, index: true, foreign_key: true
      t.references :user, foreign_key: true
      t.string :first_name, :limit => 144
      t.string :last_name, :limit => 144
      t.string :phone_number, :limit => 255
      t.string :email, :limit => 255
      t.date :date_of_birth
      t.string :gender, default: "undisclosed"
      t.string :country
      t.string :city
      t.string :zip
      t.string :address
      t.string :time_zone, default: "UTC"

      t.boolean :active, default: true
      t.boolean :online_booking, default: true
      t.integer :balance, default: 0, null: false
      t.integer :transactions_sum, default: 0, null: false
      t.integer :event_earnings_sum, default: 0, null: false
      t.integer :transactions_count, :integer, default: 0, null: false
      t.integer :jobs_count, :integer, default: 0, null: false

      t.belongs_to :location, foreign_key: true

      t.timestamps
    end
  end
end
