class AddCodeToClients < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :code, :string
  end
end
