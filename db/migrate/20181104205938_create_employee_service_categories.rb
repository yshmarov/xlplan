class CreateEmployeeServiceCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :employee_service_categories do |t|
      t.belongs_to :employee, foreign_key: true
      t.belongs_to :service_category, foreign_key: true

      t.timestamps
    end
  end
end
