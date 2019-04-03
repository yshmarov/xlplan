class AddPolymorphicToInboundPayments < ActiveRecord::Migration[5.2]
  def change
    add_column :inbound_payments, :payable_id, :integer
    add_index :inbound_payments, :payable_id
    add_column :inbound_payments, :payable_type, :string
    add_index :inbound_payments, :payable_type
  end
end
