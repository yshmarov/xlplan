class RemoveExpencesTable < ActiveRecord::Migration[5.2]
  def change
    drop_table :expences
  end
end
