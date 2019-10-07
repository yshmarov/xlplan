class AddStatusToLeads < ActiveRecord::Migration[5.2]
  def change
    add_column :leads, :status, :string
  end
end
