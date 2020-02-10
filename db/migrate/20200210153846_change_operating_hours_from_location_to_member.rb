class ChangeOperatingHoursFromLocationToMember < ActiveRecord::Migration[5.2]
  def change
    add_reference :operating_hours, :member, foreign_key: true
    remove_reference :operating_hours, :location
  end
end
