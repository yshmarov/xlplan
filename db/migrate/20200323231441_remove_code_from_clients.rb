class RemoveCodeFromClients < ActiveRecord::Migration[5.2]
  def change
    remove_column :clients, :code
    remove_column :locations, :viber
    remove_column :locations, :whatsapp
    remove_column :locations, :telegram
    remove_column :locations, :phone_number
    remove_column :locations, :email
  end
end
