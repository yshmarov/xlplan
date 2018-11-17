class CreateClients < ActiveRecord::Migration[5.2]
  def change
    create_table :clients do |t|
      t.string :first_name, :limit => 144, null: false
      t.string :middle_name, :limit => 144
      t.string :last_name, :limit => 144, null: false
      t.date :date_of_birth
      t.string :sex, default: "undisclosed"
      t.string :email
      t.string :phone_number
      t.string :address
      t.text :description
      t.integer :status, default: 1, null: false
      t.integer :balance, default: 0, null: false
      t.belongs_to :employee, foreign_key: true

      t.timestamps
    end
  end
end
