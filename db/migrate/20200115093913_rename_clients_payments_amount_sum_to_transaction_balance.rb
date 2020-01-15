class RenameClientsPaymentsAmountSumToTransactionBalance < ActiveRecord::Migration[5.2]
  def change
    rename_column :clients, :payments_amount_sum, :transactions_sum
  end
end
