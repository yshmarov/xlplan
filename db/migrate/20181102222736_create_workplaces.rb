class CreateWorkplaces < ActiveRecord::Migration[5.2]
  def change
    create_table :workplaces do |t|
      t.references :tenant, foreign_key: true
      t.string :name, :limit => 144, null: false
      t.belongs_to :location, foreign_key: true
      t.integer :status, default: 1, null: false

      t.timestamps
    end
  end
end
