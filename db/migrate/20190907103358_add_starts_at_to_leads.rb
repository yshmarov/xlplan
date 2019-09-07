class AddStartsAtToLeads < ActiveRecord::Migration[5.2]
  def change
    add_column :leads, :starts_at, :datetime
  end
end
