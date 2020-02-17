class AddServicesServiceCategoryIndex < ActiveRecord::Migration[5.2]
  def change
    add_index :services, :service_category_id
  end
end
