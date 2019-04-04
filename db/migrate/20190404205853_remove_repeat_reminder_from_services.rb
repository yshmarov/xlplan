class RemoveRepeatReminderFromServices < ActiveRecord::Migration[5.2]
  def change
    remove_column :services, :repeat_reminder, :integer
  end
end
