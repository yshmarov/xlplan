class CreateLeads < ActiveRecord::Migration[5.2]
  def change
    create_table :leads do |t|
      t.belongs_to :tenant, index: true, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :phone_number
      t.string :email
      t.text :comment

      t.timestamps
    end
  end
end
