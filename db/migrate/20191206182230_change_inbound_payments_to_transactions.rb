class ChangeInboundPaymentsToTransactions < ActiveRecord::Migration[5.2]
  def change
    rename_table :inbound_payments, :transactions
  end
end
