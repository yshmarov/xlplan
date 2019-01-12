class AddCounters < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :jobs_count, :integer, default: 0, null: false
    add_column :members, :jobs_count, :integer, default: 0, null: false
    add_column :locations, :jobs_count, :integer, default: 0, null: false
    add_column :appointments, :jobs_count, :integer, default: 0, null: false
    add_column :services, :jobs_count, :integer, default: 0, null: false

    add_column :clients, :comments_count, :integer, default: 0, null: false

    add_column :clients, :appointments_count, :integer, default: 0, null: false
    add_column :members, :appointments_count, :integer, default: 0, null: false
    add_column :locations, :appointments_count, :integer, default: 0, null: false

    add_column :service_categories, :services_count, :integer, default: 0, null: false
  end
end
