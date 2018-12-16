class AddSlugToModels < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :slug, :string
    add_index :clients, :slug, unique: true

    add_column :members, :slug, :string
    add_index :members, :slug, unique: true

    add_column :jobs, :slug, :string
    add_index :jobs, :slug, unique: true

    add_column :services, :slug, :string
    add_index :services, :slug, unique: true

    add_column :locations, :slug, :string
    add_index :locations, :slug, unique: true
  end
end
