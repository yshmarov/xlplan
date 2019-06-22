class ChangeGenderDefaultsForClient < ActiveRecord::Migration[5.2]
  def change
   change_column :clients, :gender, :string, default: "undisclosed"
  end
end
