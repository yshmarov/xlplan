class RemoveStatusFromClients < ActiveRecord::Migration[5.2]
  def change
    remove_column :clients, :status
  end
end
