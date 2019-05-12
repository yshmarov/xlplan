class AddTimeZoneToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :time_zone, :string, default: "UTC"
  end
end
