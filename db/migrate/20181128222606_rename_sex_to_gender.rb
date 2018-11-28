class RenameSexToGender < ActiveRecord::Migration[5.2]
  def change
    rename_column :clients, :sex, :gender
    rename_column :employees, :sex, :gender
  end
end
