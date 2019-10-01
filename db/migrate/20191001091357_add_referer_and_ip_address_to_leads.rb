class AddRefererAndIpAddressToLeads < ActiveRecord::Migration[5.2]
  def change
    add_column :leads, :referer, :string
    add_column :leads, :ip_address, :string
  end
end
