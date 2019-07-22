class AddExpencesAmountSumToMembers < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :expences_amount_sum, :integer, default: 0, null: false
  end
end
