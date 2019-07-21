class AddClientDuePriceToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :event_due_price, :integer, default: 0, null: false
  end
end
