class RemoveAddPercentFromEvents < ActiveRecord::Migration[5.2]
  def change
    remove_column :events, :add_percent
  end
end
