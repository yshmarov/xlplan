class Client < ApplicationRecord
  has_many :jobs
  has_many :comments, as: :commentable
  belongs_to :employee

  validates :status, presence: true
  #validates :person_id, uniqueness: true

  monetize :balance, as: :balance_cents

  enum status: { inactive: 0, active: 1 }

  after_touch :update_balance

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

  protected
  
  def update_balance
    update_column :balance, (jobs.map(&:client_due_price).sum)
  end

end
