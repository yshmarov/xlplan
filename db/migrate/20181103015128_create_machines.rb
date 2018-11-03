class CreateMachines < ActiveRecord::Migration[5.2]
  def change
    create_table :machines do |t|
      t.string :name, :limit => 144, null: false
      t.belongs_to :location, foreign_key: true
      t.integer :status, default: 0, null: false

      t.timestamps
    end
    add_index :machines, :name, unique: true
  end
end
