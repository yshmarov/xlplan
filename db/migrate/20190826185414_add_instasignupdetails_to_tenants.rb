class AddInstasignupdetailsToTenants < ActiveRecord::Migration[5.2]
  def change
    add_column :tenants, :phone, :string
    add_column :tenants, :coupon, :string
  end
end
