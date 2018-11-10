class Employee < ApplicationRecord
  belongs_to :person
  belongs_to :location
  has_many :jobs

  validates :person_id, :location_id, :status, presence: true
  validates :person_id, uniqueness: true
  validate :termination_date_cannot_be_before_employment_date
  
  monetize :balance, as: :balance_cents
  after_touch :update_balance

  #scope :active, -> { where(status: 0) }

  enum status: [:"Active", :"Inactive"]

  def to_s
    person
  end

  def termination_date_cannot_be_before_employment_date
    if termination_date.present? && termination_date <= employment_date
      errors.add(:termination_date, "can't be before employment date")
    end
  end

  protected
  
  def update_balance
    update_column :balance, (jobs.map(&:employee_price).sum)
  end

end
