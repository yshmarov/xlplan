class RemoveIndexFromServicesName < ActiveRecord::Migration[5.2]
  def change
    remove_index "services", name: "index_services_on_service_category_id"
    remove_index "services", name: "index_services_on_name"
  end
end
