class RemoveSomeNonRelatedMemberFields < ActiveRecord::Migration[5.2]
  def change
    remove_column :members, :gender
    remove_column :members, :country
    remove_column :members, :city
    remove_column :members, :zip
    remove_column :members, :address
  end
end
