class AddCounters < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :jobs_count, :integer, default: 0, null: false
    add_column :events, :jobs_count, :integer, default: 0, null: false
    add_column :services, :jobs_count, :integer, default: 0, null: false

    add_column :clients, :comments_count, :integer, default: 0, null: false

    add_column :clients, :events_count, :integer, default: 0, null: false
    add_column :locations, :events_count, :integer, default: 0, null: false

    add_column :service_categories, :services_count, :integer, default: 0, null: false
  end
end
