class AddAcceptConditionsToLeads < ActiveRecord::Migration[5.2]
  def change
    add_column :leads, :conditions_consent, :boolean
  end
end
