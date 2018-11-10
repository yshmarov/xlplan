class AddJobsCount < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :jobs_count, :integer
    add_column :employees, :jobs_count, :integer
    add_column :locations, :jobs_count, :integer
    add_column :services, :jobs_count, :integer
  end
end
