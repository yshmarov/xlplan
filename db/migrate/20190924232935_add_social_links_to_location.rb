class AddSocialLinksToLocation < ActiveRecord::Migration[5.2]
  def change
    add_column :locations, :viber, :string, :limit => 40
    add_column :locations, :telegram, :string, :limit => 40
    add_column :locations, :whatsapp, :string, :limit => 40
  end
end
