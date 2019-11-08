class AddSlugsToCashouts < ActiveRecord::Migration[5.2]
  def change
    add_column :cashouts, :slug, :string
    add_index :cashouts, :slug, unique: true
  end
end
