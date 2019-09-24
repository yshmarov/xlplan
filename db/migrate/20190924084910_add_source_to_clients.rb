class AddSourceToClients < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :lead_source, :string, default: "direct"
  end
end
