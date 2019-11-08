class RenameEventAmountOffToAddAmount < ActiveRecord::Migration[5.2]
  def change
    rename_column :events, :amount_off, :add_amount
  end
end
