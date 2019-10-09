class AddClientIdToLeads < ActiveRecord::Migration[5.2]
  def change
    add_reference :leads, :client, foreign_key: true, index: true
  end
end
