class AddTenantToOperatingHours < ActiveRecord::Migration[5.2]
  def change
    add_reference :operating_hours, :tenant, foreign_key: true, index: true
  end
end
