class ChangeDefaultValuesForBooleans < ActiveRecord::Migration[5.2]
  def change
    change_column :locations, :active, :boolean, default: true
    change_column :members, :active, :boolean, default: true
    change_column :services, :active, :boolean, default: true
  end
end
