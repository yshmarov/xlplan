class ChangeDefaultForOnlineBooking < ActiveRecord::Migration[5.2]
  def change
    change_column :locations, :online_booking, :boolean, default: true
    change_column :members, :online_booking, :boolean, default: true
    change_column :services, :online_booking, :boolean, default: true
  end
end
