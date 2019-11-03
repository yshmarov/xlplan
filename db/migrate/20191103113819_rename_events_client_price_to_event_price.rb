class RenameEventsClientPriceToEventPrice < ActiveRecord::Migration[5.2]
  def change
    rename_column :events, :client_price, :event_price
  end
end
