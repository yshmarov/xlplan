class Employee < ApplicationRecord
  belongs_to :person
  belongs_to :location
  has_many :jobs

  validates :person_id, :location_id, :status, presence: true
  validates :person_id, uniqueness: true

  monetize :balance, as: :balance_cents
  after_touch :update_balance

  def to_s
    person
  end

  enum status: [:"Active", :"Inactive"]

  protected
  
  def update_balance
    update_column :balance, (jobs.map(&:employee_price).sum)
  end

end
