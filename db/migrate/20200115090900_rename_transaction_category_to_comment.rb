class RenameTransactionCategoryToComment < ActiveRecord::Migration[5.2]
  def change
    rename_column :transactions, :category, :comment
  end
end
