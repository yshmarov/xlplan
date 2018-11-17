class Employee < ApplicationRecord
  has_one :user
  belongs_to :location
  has_many :jobs
  has_many :skills
  has_many :service_categories, through: :skills
  has_many :clients

  validates :location_id, :status, presence: true
  validate :termination_date_cannot_be_before_employment_date
  
  monetize :balance, as: :balance_cents
  after_touch :update_balance

  enum status: { inactive: 0, active: 1 }

  def full_name
    last_name.capitalize + " " + first_name.capitalize
  end

  def age
    if date_of_birth.present?
      now = Time.now.utc.to_date
      now.year - date_of_birth.year - ((now.month > date_of_birth.month || (now.month == date_of_birth.month && now.day >= date_of_birth.day)) ? 0 : 1)
    end
  end

  def to_s
    full_name
  end

  def termination_date_cannot_be_before_employment_date
    if termination_date.present? && termination_date <= employment_date
      errors.add(:termination_date, "can't be before employment date")
    end
  end

  protected
  
  def update_balance
    update_column :balance, (jobs.map(&:employee_due_price).sum)
  end

end
