class AddJobsDuePriceSumToMembers < ActiveRecord::Migration[5.2]
  def change
    add_column :members, :jobs_due_price_sum, :integer, default: 0, null: false
  end
end
