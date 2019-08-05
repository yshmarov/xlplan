class AddExpencesCountToMembers < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :expences_count, :integer, default: 0, null: false
  end
end
