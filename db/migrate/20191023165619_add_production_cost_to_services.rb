class AddProductionCostToServices < ActiveRecord::Migration[5.2]
  def change
    add_column :services, :production_cost, :integer, default: 0, null: false
  end
end
