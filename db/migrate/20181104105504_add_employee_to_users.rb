class AddEmployeeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :employee, foreign_key: true
  end
end
