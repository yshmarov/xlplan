class AddOnlineBookingBooleans < ActiveRecord::Migration[5.2]
  def change
    add_column :tenants, :online_booking, :boolean, default: false
    add_column :services, :online_booking, :boolean, default: false
    add_column :members, :online_booking, :boolean, default: false
    add_column :locations, :online_booking, :boolean, default: false
  end
end
