class AddBooleansToClients < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :personal_data_consent, :boolean, default: true
    add_column :clients, :event_created_notifications, :boolean, default: true
    add_column :clients, :marketing_notifications, :boolean, default: true
  end
end
