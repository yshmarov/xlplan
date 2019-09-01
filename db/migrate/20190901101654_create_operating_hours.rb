class CreateOperatingHours < ActiveRecord::Migration[5.2]
  def change
    create_table :operating_hours do |t|
      t.belongs_to :location, index: true
      t.integer :day_of_week
      t.time :closes
      t.time :opens
      t.datetime :valid_from
      t.datetime :valid_through
    end
  end
end
