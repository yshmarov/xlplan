class CreateEmployees < ActiveRecord::Migration[5.2]
  def change
    create_table :employees do |t|
      t.belongs_to :tenant, index: true, foreign_key: true

      t.belongs_to :member, index: true, foreign_key: true

      t.integer :status, default: 1, null: false
      t.integer :balance, default: 0, null: false

      t.belongs_to :location, foreign_key: true
      t.date :employment_date
      t.date :termination_date

      t.timestamps
    end
  end
end
