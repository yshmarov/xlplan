class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts do |t|
      t.belongs_to :tenant, index: true, foreign_key: true

      t.string :email
      t.string :import_id
      t.string :name
      t.string :first_name
      t.string :last_name
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :region
      t.string :postcode
      t.string :country
      t.string :phone_number
      t.string :birthday
      t.string :gender
      t.string :relation

      t.timestamps
    end
  end
end
