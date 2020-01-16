class IncreaseServiceDescriptionMaxLength < ActiveRecord::Migration[5.2]
  def change
    change_column :services, :description, :string
  end
end
