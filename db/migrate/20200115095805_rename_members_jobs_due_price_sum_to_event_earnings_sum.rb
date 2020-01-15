class RenameMembersJobsDuePriceSumToEventEarningsSum < ActiveRecord::Migration[5.2]
  def change
    rename_column :members, :jobs_due_price_sum, :event_earnings_sum
  end
end
