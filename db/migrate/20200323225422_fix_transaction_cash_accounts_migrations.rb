class FixTransactionCashAccountsMigrations < ActiveRecord::Migration[5.2]
  def change
    remove_column :transactions, :cash_accounts_id
    remove_column :events, :workplaces_id
  end
end
