class AddWorkplaceToEvents < ActiveRecord::Migration[5.2]
  def change
    add_reference :events, :workplace, foreign_key: true
  end
end
