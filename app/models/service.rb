class Service < ApplicationRecord
  validates :name, uniqueness: true
  validates :name, :duration, :client_price_cents, :employee_price_cents, :quantity, :status, :category_id, presence: true
  monetize :client_price_cents
  monetize :employee_price_cents

  belongs_to :category
  has_many :jobs
  #has_many :employee_services

  #after_update :update_employee_price
  after_save :update_employee_price
  def update_employee_price
    update_column :employee_price_cents, (client_price_cents*employee_percent/100)
  end
  
  def to_s
    name
  end

  def full_name
    name.to_s+'('+description.to_s+'/'+category.to_s+')('+client_price_cents.to_i.to_s+'/'+employee_price_cents.to_i.to_s+')'
  end

  #def total_price
  #  client_price*quantity
  #end

  enum status: [:"Active", :"Inactive"]

end
