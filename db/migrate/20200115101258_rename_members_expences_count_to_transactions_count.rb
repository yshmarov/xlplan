class RenameMembersExpencesCountToTransactionsCount < ActiveRecord::Migration[5.2]
  def change
    rename_column :members, :expences_count, :transactions_count
  end
end
