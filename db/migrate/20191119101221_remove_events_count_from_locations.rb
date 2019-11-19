class RemoveEventsCountFromLocations < ActiveRecord::Migration[5.2]
  def change
    remove_column :locations, :events_count
  end
end
