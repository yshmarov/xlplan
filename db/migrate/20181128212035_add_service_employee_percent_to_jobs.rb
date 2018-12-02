class AddServiceEmployeePercentToJobs < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs, :service_employee_percent, :integer, default: 0, null: false
  end
end