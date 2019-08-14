class AddEventsAmountSumToLocations < ActiveRecord::Migration[5.2]
  def change
    add_column :locations, :events_amount_sum, :integer, default: 0, null: false
  end
end
