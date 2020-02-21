class AddMissingReferencesUpdated < ActiveRecord::Migration[5.2]
  def change
    remove_reference :workplaces, :events, index: true
    remove_reference :cash_accounts, :transactions, index: true

    add_reference :events, :workplaces, index: true
    add_reference :transactions, :cash_accounts, index: true
  end
end
