class AddTypeToTransactions < ActiveRecord::Migration[5.2]
  def change
    add_column :transactions, :category, :string, :limit => 144
  end
end
