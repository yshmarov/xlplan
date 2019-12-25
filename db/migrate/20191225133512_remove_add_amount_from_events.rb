class RemoveAddAmountFromEvents < ActiveRecord::Migration[5.2]
  def change
    remove_column :events, :add_amount
  end
end
