class Client < ApplicationRecord

  after_touch :update_balance

  acts_as_tenant

  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }
  include Personable
  extend FriendlyId
  friendly_id :full_name, use: :slugged

  has_many :appointments, dependent: :restrict_with_error
  has_many :jobs, through: :appointments
  has_many :comments, as: :commentable

  validates :first_name, :last_name, presence: true
  validates :status, presence: true

  #email has to be present with below validation
  #validates :email, uniqueness: { case_sensitive: false }
  #VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  #validates :email, format: { with: VALID_EMAIL_REGEX }

  monetize :balance, as: :balance_cents

  enum status: { inactive: 0, active: 1 }

  ransacker :full_name do |parent|
    Arel::Nodes::InfixOperation.new('||',
      Arel::Nodes::InfixOperation.new('||',
        parent.table[:first_name], Arel::Nodes.build_quoted(' ')
      ),
      parent.table[:last_name]
    )
  end

  def associations?
    jobs.any?
  end

  #private
  #protected

  def update_balance
    update_column :balance, (jobs.map(&:client_due_price).sum*(-1))
  end

end
