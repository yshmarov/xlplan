class RemoveBalanceFromLocations < ActiveRecord::Migration[5.2]
  def change
    remove_column :locations, :balance
  end
end
