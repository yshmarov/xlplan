class Client < ApplicationRecord
  belongs_to :person
  belongs_to :employee
  has_many :jobs
  has_many :comments, as: :commentable


  validates :person_id, :employee_id, :status, presence: true
  validates :person_id, uniqueness: true

  monetize :balance, as: :balance_cents
  after_touch :update_balance

  def to_s
    person
  end

  enum status: [:"Active", :"Inactive"]

  protected
  
  def update_balance
    update_column :balance, (jobs.map(&:client_price).sum)
  end

end
