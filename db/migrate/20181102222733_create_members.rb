class CreateMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :members do |t|
      t.belongs_to :tenant, index: true, foreign_key: true
      t.references :user, foreign_key: true
      t.string :first_name, :limit => 144
      t.string :last_name, :limit => 144

      t.timestamps
    end
  end
end
