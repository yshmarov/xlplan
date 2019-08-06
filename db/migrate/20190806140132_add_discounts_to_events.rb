class AddDiscountsToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :percent_off, :integer, default: 0, null: false
    add_column :events, :amount_off, :integer, default: 0, null: false
  end
end
