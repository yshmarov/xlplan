class AddMissingReferencesUpdated < ActiveRecord::Migration[5.2]
  def change
    add_reference :events, :workplace, index: true
    add_reference :transactions, :cash_account, index: true

    add_reference :events, :workplaces, index: true
    add_reference :transactions, :cash_accounts, index: true
  end
end
