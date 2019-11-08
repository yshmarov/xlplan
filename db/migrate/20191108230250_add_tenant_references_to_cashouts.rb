class AddTenantReferencesToCashouts < ActiveRecord::Migration[5.2]
  def change
    add_reference :cashouts, :tenant, index: true, foreign_key: true
  end
end
