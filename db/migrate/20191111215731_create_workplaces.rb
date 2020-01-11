class CreateWorkplaces < ActiveRecord::Migration[5.2]
  def change
    create_table :workplaces do |t|
      t.belongs_to :tenant, index: true, foreign_key: true
      t.belongs_to :location, foreign_key: true
      t.string :name, :limit => 20, null: false
      t.integer :events_count, :integer, default: 0, null: false

      t.timestamps
    end
  end
end
