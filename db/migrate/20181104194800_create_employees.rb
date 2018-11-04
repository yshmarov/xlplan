class CreateEmployees < ActiveRecord::Migration[5.2]
  def change
    create_table :employees do |t|
      t.belongs_to :person, foreign_key: true
      t.belongs_to :location, foreign_key: true
      t.string :specialization
      t.date :employment_date
      t.date :termination_date
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
