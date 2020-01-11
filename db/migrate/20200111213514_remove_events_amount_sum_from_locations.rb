class RemoveEventsAmountSumFromLocations < ActiveRecord::Migration[5.2]
  def change
    remove_column :locations, :events_amount_sum
  end
end
