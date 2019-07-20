class Client < ApplicationRecord
  include Personable
  #-----------------------callbacks-------------------#
  after_touch :update_balance
  #-----------------------gem milia-------------------#
  acts_as_tenant
  #-----------------------gem public_activity-------------------#
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }
  tracked tenant_id: Proc.new{ Tenant.current_tenant.id }
  #-----------------------gem friendly_id-------------------#
  extend FriendlyId
  friendly_id :full_name, use: :slugged
  #-----------------------relationships-------------------#
  has_many :events, dependent: :restrict_with_error
  has_many :jobs, through: :events
  has_many :services, through: :jobs
  has_many :comments, as: :commentable
  has_many :inbound_payments, dependent: :restrict_with_error
  #-----------------------validation-------------------#
  validates :first_name, :last_name, presence: true
  validates :first_name, :last_name, length: { maximum: 144 }
  validates :status, presence: true
  validates :slug, uniqueness: true
  validates :slug, uniqueness: { case_sensitive: false }
  validates :gender, inclusion: %w(male female undisclosed)
  #email has to be present with below validation
  #validates :email, uniqueness: { case_sensitive: false }
  #VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  #validates :email, format: { with: VALID_EMAIL_REGEX }
  #-----------------------serialization-------------------#
  #serialize :address, Hash
  serialize :address
  #store :address, accessors: [:street_address, :city, :state, :zip], coder: JSON
  #-----------------------enums-------------------#
  enum status: { inactive: 0, active: 1 }
  #-----------------------scopes-------------------#
  scope :debtors, -> { where("balance < ?", 0) }
  #-----------------------money gem-------------------#
  monetize :balance, as: :balance_cents
  monetize :payments_amount_sum, as: :payments_amount_sum_cents
  monetize :jobs_amount_sum, as: :jobs_amount_sum_cents
  #-----------------------Ransack full_name-------------------#
  ransacker :full_name do |parent|
    Arel::Nodes::InfixOperation.new('||',
      Arel::Nodes::InfixOperation.new('||',
        parent.table[:first_name], Arel::Nodes.build_quoted(' ')
      ),
      parent.table[:last_name]
    )
  end

  #private
  #protected

  def update_balance
    #update_column :balance, (inbound_payments.map(&:amount).sum-jobs.map(&:client_due_price).sum)
    update_column :payments_amount_sum, (inbound_payments.map(&:amount).sum)
    update_column :jobs_amount_sum, (jobs.map(&:client_due_price).sum)
    update_column :balance, (payments_amount_sum - update_jobs_amount_sum)
  end
end