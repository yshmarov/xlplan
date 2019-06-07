class CreateExpences < ActiveRecord::Migration[5.2]
  def change
    create_table :expences do |t|
      t.belongs_to :tenant, index: true, foreign_key: true
      t.integer :amount, default: 0, null: false
      t.string :payment_method, default: 'cash', null: false
      t.string :expendable_type
      t.integer :expendable_id
      t.string :slug

      t.timestamps
    end
    add_index :expences, :expendable_type
    add_index :expences, :expendable_id
    add_index :expences, :slug, unique: true
  end
end
