class CreateClients < ActiveRecord::Migration[5.2]
  def change
    create_table :clients do |t|
      t.belongs_to :person, foreign_key: true
      t.belongs_to :employee, foreign_key: true
      t.integer :balance, default: 0, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
