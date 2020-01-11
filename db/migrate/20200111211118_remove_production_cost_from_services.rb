class RemoveProductionCostFromServices < ActiveRecord::Migration[5.2]
  def change
    remove_column :services, :production_cost
  end
end
