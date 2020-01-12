class RemoveClientFromTransaction < ActiveRecord::Migration[5.2]
  def change
    remove_column :transactions, :client_id
  end
end
