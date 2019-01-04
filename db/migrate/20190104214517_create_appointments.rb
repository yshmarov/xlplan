class CreateAppointments < ActiveRecord::Migration[5.2]
  def change
    create_table :appointments do |t|
      t.belongs_to :tenant, index: true, foreign_key: true
      t.references :client, foreign_key: true
      t.references :member, foreign_key: true
      t.references :location, foreign_key: true
      t.datetime :starts_at
      t.datetime :ends_at
      t.integer :status, default: 0, null: false
      t.text :description
      t.string :status_color, default: 'blue'

      t.timestamps
    end
  end
end
