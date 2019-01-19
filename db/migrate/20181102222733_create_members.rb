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
      t.text :address

      t.integer :status, default: 1, null: false
      t.integer :balance, default: 0, null: false

      t.belongs_to :location, foreign_key: true

      t.timestamps
    end
  end
end
