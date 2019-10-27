class CreateCashouts < ActiveRecord::Migration[5.2]
  def change
    create_table :cashouts do |t|
      t.references :location, foreign_key: true, index: true, null: false
      t.integer :amount, default: 0, null: false
      t.references :member, foreign_key: true, index: true, null: false
      t.timestamps
    end
  end
end
