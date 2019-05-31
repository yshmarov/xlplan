class AddSlugToServiceCategories < ActiveRecord::Migration[5.2]
  def change
    add_column :service_categories, :slug, :string
    add_index :service_categories, :slug, unique: true
  end
end
