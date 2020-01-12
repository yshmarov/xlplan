class TransactionsBelongToCashAccounts < ActiveRecord::Migration[5.2]
  def change
    add_reference :transactions, :cash_account, index: true
  end
end
