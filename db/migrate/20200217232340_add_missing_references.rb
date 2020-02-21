class AddMissingReferences < ActiveRecord::Migration[5.2]
  def change
    add_reference :workplaces, :events, index: true
    add_reference :cash_accounts, :transactions, index: true
  end
end
