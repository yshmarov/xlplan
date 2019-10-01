class AddCouponToLeads < ActiveRecord::Migration[5.2]
  def change
    add_column :leads, :coupon, :string, :limit => 144
  end
end
