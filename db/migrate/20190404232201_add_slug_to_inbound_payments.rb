class AddSlugToInboundPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :inbound_payments, :slug, :string
    add_index :inbound_payments, :slug, unique: true
  end
end
