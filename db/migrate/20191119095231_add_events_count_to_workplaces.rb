class AddEventsCountToWorkplaces < ActiveRecord::Migration[5.2]
  def change
    add_column :workplaces, :events_count, :integer, default: 0, null: false
  end
end
