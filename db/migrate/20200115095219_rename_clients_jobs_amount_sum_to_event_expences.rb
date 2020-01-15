class RenameClientsJobsAmountSumToEventExpences < ActiveRecord::Migration[5.2]
  def change
    rename_column :clients, :jobs_amount_sum, :event_expences_sum
  end
end
