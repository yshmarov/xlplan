class CreateClients < ActiveRecord::Migration[5.2]
  def change
    create_table :clients do |t|
      t.belongs_to :tenant, index: true, foreign_key: true
      t.string :first_name, limit: 144, null: false
      t.string :last_name, limit: 144, null: false
      t.string :phone_number
      t.string :email
      t.date :date_of_birth
      t.string :gender, default: "undisclosed"
      t.string :country
      t.string :city
      t.string :zip
      t.string :address
      t.string :lead_source, default: "direct"

      t.boolean :personal_data_consent, default: true
      t.boolean :event_created_notifications, default: true
      t.boolean :marketing_notifications, default: true

      t.integer :transactions_sum, default: 0, null: false
      t.integer :event_expences_sum, default: 0, null: false
      t.integer :balance, default: 0, null: false

      t.integer :comments_count, default: 0, null: false
      t.integer :transactions_count, default: 0, null: false
      t.integer :events_count, default: 0, null: false

      t.timestamps
    end
  end
end
