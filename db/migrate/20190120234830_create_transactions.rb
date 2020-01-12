class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.belongs_to :tenant, index: true, foreign_key: true
      t.references :client, foreign_key: true
      t.references :cash_account, index: true, foreign_key: true
      t.integer :amount, default: 0, null: false
      t.integer :payable_id
      t.string :payable_type
      t.string :category, :limit => 144
      t.string :slug

      t.timestamps
    end
    add_index :transactions, :payable_id
    add_index :transactions, :payable_type
    add_index :transactions, :slug, unique: true
  end
end
