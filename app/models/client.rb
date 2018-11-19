class Client < ApplicationRecord
  include Personable
  has_many :jobs
  has_many :comments, as: :commentable
  belongs_to :employee

  validates :first_name, :last_name, presence: true
  validates :status, presence: true
  #validates :email, uniqueness: { case_sensitive: false }
  #VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  #validates :email, format: { with: VALID_EMAIL_REGEX }

  monetize :balance, as: :balance_cents

  enum status: { inactive: 0, active: 1 }

  after_touch :update_balance

  #def full_name
  #  last_name.capitalize + " " + first_name.capitalize
  #end

  protected
  
  def update_balance
    update_column :balance, (jobs.map(&:client_due_price).sum*(-1))
  end

end
