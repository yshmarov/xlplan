class AddServiceClientPriceToJobs < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs, :service_client_price, :integer, default: 0, null: false
  end
end
