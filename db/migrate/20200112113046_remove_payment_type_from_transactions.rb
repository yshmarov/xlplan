class RemovePaymentTypeFromTransactions < ActiveRecord::Migration[5.2]
  def change
    remove_column :transactions, :payment_method
  end
end
