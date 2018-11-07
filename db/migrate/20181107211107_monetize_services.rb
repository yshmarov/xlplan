class MonetizeServices < ActiveRecord::Migration[5.2]
  def change
    add_monetize :services, :client_price
    add_monetize :services, :employee_price
  end
end
