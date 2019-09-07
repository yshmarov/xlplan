class Client < ApplicationRecord
  include Personable
  #-----------------------gem milia-------------------#
  acts_as_tenant
  #-----------------------callbacks-------------------#
  after_touch :update_balance
  #-----------------------gem public_activity-------------------#
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }
  tracked tenant_id: Proc.new{ Tenant.current_tenant.id }
  #-----------------------gem friendly_id-------------------#
  extend FriendlyId
  friendly_id :full_name, use: :slugged
  #-----------------------relationships-------------------#
  has_one_attached :avatar
  has_many :events, dependent: :restrict_with_error
  has_many :jobs, through: :events
  has_many :services, through: :jobs
  has_many :comments, as: :commentable
  has_many :inbound_payments, dependent: :restrict_with_error
  has_one :contact, inverse_of: :client, dependent: :nullify
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
  def address_line
    if address.present?
      [address[:country], address[:city], address[:street], address[:zip]].join(', ')
    end
  end
  #-----------------------enums-------------------#
  enum status: { inactive: 0, active: 1 }
  #-----------------------scopes-------------------#
  scope :debtors, -> { where("balance < ?", 0) }
  scope :no_gender, -> { where(gender: "undisclosed") }
  scope :had_events_but_no_planned_events, -> {joins(:events).where.not('events.starts_at >=?', Time.zone.now).distinct }
  scope :bday_today, -> { where("EXTRACT(DOY FROM date_of_birth) = ?", Time.zone.now.yday) }
  #@clients = Client.where("EXTRACT(YEAR FROM date_of_birth) >= ?", 1948).where("EXTRACT(DOY FROM date_of_birth) = ?", Time.zone.now.yday).order(Arel.sql('EXTRACT (DOY FROM date_of_birth) ASC'))
  #@clients = Client.where("EXTRACT(YEAR FROM date_of_birth) >= ?", Date.today.year - 65).where("EXTRACT(DOY FROM date_of_birth) = ?", Time.zone.now.yday).order(Arel.sql('EXTRACT (DOY FROM date_of_birth) ASC'))
  #-----------------------money gem-------------------#
  monetize :balance, as: :balance_cents
  monetize :payments_amount_sum, as: :payments_amount_sum_cents
  monetize :jobs_amount_sum, as: :jobs_amount_sum_cents
  #-----------------------Ransack first_name or last_name-------------------#
  ransacker :full_name do |parent|
    Arel::Nodes::InfixOperation.new('||',
      Arel::Nodes::InfixOperation.new('||',
        parent.table[:first_name], Arel::Nodes.build_quoted(' ')
      ),
      parent.table[:last_name]
    )
  end
  #-----------------------last and next event-------------------#
  def next_event
    events.where("starts_at >= ?", Time.zone.now).order("starts_at ASC").pluck(:starts_at).first
  end
  def last_event
    events.where("starts_at <= ?", Time.zone.now).order("starts_at DESC").pluck(:starts_at).first
  end
  #-----------------------callbacks details-------------------#
  #private
  #protected
  def update_balance
    #update_column :balance, (inbound_payments.map(&:amount).sum-jobs.map(&:client_due_price).sum)
    update_column :payments_amount_sum, (inbound_payments.map(&:amount).sum)
    update_column :jobs_amount_sum, (events.map(&:event_due_price).sum)
    update_column :balance, (payments_amount_sum - jobs_amount_sum)
  end
end