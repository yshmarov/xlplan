class Location < ApplicationRecord
  validates :name, uniqueness: true
  validates :name, :balance, :status, presence: true

  has_many :machines
  has_many :employees
  has_many :jobs

  after_touch :update_balance
  def update_balance
    update_column :balance, (balance)
  end
  
  def to_s
    name
  end

  enum status: [:"Active", :"Inactive"]

end
