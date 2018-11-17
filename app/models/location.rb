class Location < ApplicationRecord
  has_many :workplaces
  has_many :employees
  has_many :jobs

  validates :name, uniqueness: true
  validates :name, :balance, :status, presence: true

  enum status: { inactive: 0, active: 1 }

  monetize :balance, as: :balance_cents

  after_touch :update_balance

  def to_s
    name
  end

  protected

  def update_balance
    update_column :balance, (jobs.map(&:client_due_price).sum)
  end

end
