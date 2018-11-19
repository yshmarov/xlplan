class AddCounters < ActiveRecord::Migration[5.2]
  def change
    add_column :locations, :workplaces_count, :integer, default: 0, null: false
    add_column :service_categories, :services_count, :integer, default: 0, null: false
    add_column :clients, :comments_count, :integer, default: 0, null: false
  end
end
