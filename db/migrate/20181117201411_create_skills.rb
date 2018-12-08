class CreateSkills < ActiveRecord::Migration[5.2]
  def change
    create_table :skills do |t|
      t.belongs_to :tenant, index: true, foreign_key: true
      t.belongs_to :employee, foreign_key: true
      t.belongs_to :service_category, foreign_key: true

      t.timestamps
    end
  end
end
