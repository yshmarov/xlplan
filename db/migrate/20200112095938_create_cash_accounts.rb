class CreateCashAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :cash_accounts do |t|
      t.belongs_to :tenant, index: true, foreign_key: true
      t.string :name, :limit => 144, null: false
      t.boolean :active, default: true
      t.integer :balance, default: 0, null: false
      t.string :slug

      t.timestamps
    end
    add_index :cash_accounts, :slug, unique: true
  end
end
