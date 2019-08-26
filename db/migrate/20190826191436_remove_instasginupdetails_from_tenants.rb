class RemoveInstasginupdetailsFromTenants < ActiveRecord::Migration[5.2]
  def change
    remove_column :tenants, :coupon
    remove_column :tenants, :phone
  end
end
