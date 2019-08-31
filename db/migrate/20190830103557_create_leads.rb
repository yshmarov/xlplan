class CreateLeads < ActiveRecord::Migration[5.2]
  def change
    create_table :leads do |t|
      t.belongs_to :tenant, index: true, foreign_key: true
      t.string :first_name, :limit => 144, null: false
      t.string :last_name, :limit => 144, null: false
      t.string :phone_number, :limit => 255, null: false
      t.string :email, :limit => 255
      t.text :comment, :limit => 500
      t.belongs_to :location, foreign_key: true
      t.belongs_to :service, foreign_key: true
      t.belongs_to :member, foreign_key: true

      t.timestamps
    end
  end
end
