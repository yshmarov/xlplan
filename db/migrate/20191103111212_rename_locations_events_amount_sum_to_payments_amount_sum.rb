class RenameLocationsEventsAmountSumToPaymentsAmountSum < ActiveRecord::Migration[5.2]
  def change
    rename_column :locations, :events_amount_sum, :payments_amount_sum
  end
end
