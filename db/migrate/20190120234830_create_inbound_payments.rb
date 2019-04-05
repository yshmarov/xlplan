class CreateInboundPayments < ActiveRecord::Migration[5.2]
  def change
    create_table :inbound_payments do |t|
      t.belongs_to :tenant, index: true, foreign_key: true
      t.references :client, foreign_key: true
      t.integer :amount, default: 0, null: false
      t.string :payment_method, default: 'cash', null: false
      t.integer :payable_id
      t.string :payable_type

      t.timestamps
    end
    add_index :inbound_payments, :payable_id
    add_index :inbound_payments, :payable_type
  end
end
