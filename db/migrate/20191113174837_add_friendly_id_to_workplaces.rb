class AddFriendlyIdToWorkplaces < ActiveRecord::Migration[5.2]
  def change
    add_column :workplaces, :slug, :string
    add_index :workplaces, :slug, unique: true
  end
end
