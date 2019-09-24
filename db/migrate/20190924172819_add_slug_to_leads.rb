class AddSlugToLeads < ActiveRecord::Migration[5.2]
  def change
    add_column :leads, :slug, :string
    add_index :leads, :slug, unique: true
  end
end
