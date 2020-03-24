class RemoteDobFromMembers < ActiveRecord::Migration[5.2]
  def change
    remove_column :members, :date_of_birth
  end
end
