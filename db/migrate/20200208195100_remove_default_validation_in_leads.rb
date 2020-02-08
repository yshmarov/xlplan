class RemoveDefaultValidationInLeads < ActiveRecord::Migration[5.2]
  def change
    change_column_null :leads, :first_name, true
    change_column_null :leads, :last_name, true
    change_column_null :leads, :phone_number, true
  end
end
