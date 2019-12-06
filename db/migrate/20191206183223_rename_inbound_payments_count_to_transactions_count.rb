class RenameInboundPaymentsCountToTransactionsCount < ActiveRecord::Migration[5.2]
  def change
    rename_column :clients, :inbound_payments_count, :transactions_count
  end
end
