class Location < ApplicationRecord

  acts_as_tenant

  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }

  has_many :employees, dependent: :restrict_with_error
  has_many :jobs, dependent: :restrict_with_error

  validates :name, uniqueness: true
  validates :name, :balance, :status, presence: true

  enum status: { inactive: 0, active: 1 }

  monetize :balance, as: :balance_cents

  after_touch :update_balance

  def to_s
    name
  end

  def associations?
    jobs.any? || employees.any?
  end

  #protected

  def update_balance
    update_column :balance, (jobs.map(&:client_due_price).sum)
  end

end
