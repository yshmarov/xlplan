class AddActiveBooleanToModels < ActiveRecord::Migration[5.2]
  def change
    add_column :locations, :active, :boolean, default: true
    add_column :members, :active, :boolean, default: true
    add_column :services, :active, :boolean, default: true
    remove_column :locations, :status
    remove_column :members, :status
    remove_column :services, :status
  end
end
