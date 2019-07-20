class AddPaymentsAmountSumAndJobsAmountSumToClients < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :payments_amount_sum, :integer, default: 0, null: false
    add_column :clients, :jobs_amount_sum, :integer, default: 0, null: false
  end
end