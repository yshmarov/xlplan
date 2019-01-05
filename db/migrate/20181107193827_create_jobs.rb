class CreateJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :jobs do |t|
      t.belongs_to :tenant, index: true, foreign_key: true
      t.belongs_to :appointment, foreign_key: true
      t.belongs_to :service, foreign_key: true

      t.string :service_name, default: 0, null: false
      t.string :service_description, default: 0, null: false
      t.integer :service_duration, default: 0, null: false

      t.integer :service_member_percent, default: 0, null: false

      t.integer :client_price, default: 0, null: false
      t.integer :client_due_price, default: 0, null: false
      t.integer :member_price, default: 0, null: false
      t.integer :member_due_price, default: 0, null: false

      t.integer :created_by, default: 0, null: false

      t.timestamps

      #add_index :jobs, :status

    end
  end
end
