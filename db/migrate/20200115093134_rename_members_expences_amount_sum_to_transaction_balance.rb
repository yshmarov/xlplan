class RenameMembersExpencesAmountSumToTransactionBalance < ActiveRecord::Migration[5.2]
  def change
    rename_column :members, :expences_amount_sum, :transactions_sum
  end
end
