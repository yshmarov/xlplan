class Service < ApplicationRecord
  validates :name, uniqueness: true
  validates :name, :description, :duration, :client_price, :employee_price, :quantity, :status, :category_id, presence: true

  belongs_to :category
  #has_many :employee_services

  #after_update :update_employee_price
  after_save :update_employee_price
  def update_employee_price
    update_column :employee_price, (client_price*employee_percent/100)
  end
  
  def to_s
    name
  end

  #def total_price
  #  client_price*quantity
  #end

  enum status: [:"Active", :"Inactive"]

end
