class StandardAddressFieldsFormClientsMembersLocations < ActiveRecord::Migration[5.2]
  def change
    remove_column :members, :address
    remove_column :clients, :address
    remove_column :locations, :address
    add_column :members, :country, :string
    add_column :members, :city, :string
    add_column :members, :zip, :string
    add_column :members, :address, :string
    add_column :clients, :country, :string
    add_column :clients, :city, :string
    add_column :clients, :zip, :string
    add_column :clients, :address, :string
    add_column :locations, :country, :string
    add_column :locations, :city, :string
    add_column :locations, :zip, :string
    add_column :locations, :address, :string
  end
end
