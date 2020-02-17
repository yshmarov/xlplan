class Client < ApplicationRecord
  include Personable
  #-----------------------gem milia-------------------#
  acts_as_tenant
  #-----------------------gem public_activity-------------------#
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }
  tracked tenant_id: Proc.new{ Tenant.current_tenant.id }
  #-----------------------gem friendly_id-------------------#
  extend FriendlyId
  friendly_id :full_name, use: :slugged
  #-----------------------validation-------------------#
  validates :first_name, :last_name, presence: true
  validates :first_name, :last_name, length: { maximum: 144 }
  validates :slug, uniqueness: true
  validates :slug, uniqueness: { case_sensitive: false }
  validates :gender, inclusion: %w(male female undisclosed)
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :email, :phone_number, length: { maximum: 255 }



  #-----------------------relationships-------------------#
  has_many :transactions, as: :payable, dependent: :restrict_with_error
  has_many :leads, dependent: :restrict_with_error

  has_many :events, dependent: :restrict_with_error
  has_many :jobs, through: :events
  has_many :services, through: :jobs
  has_many :comments, as: :commentable
  has_one :contact, inverse_of: :client, dependent: :nullify
  has_many :client_tags, inverse_of: :client, dependent: :destroy
  has_many :tags, through: :client_tags
  #-----------------------money gem-------------------#
  monetize :balance, as: :balance_cents
  monetize :event_expences_sum, as: :event_expences_sum_cents
  monetize :transactions_sum, as: :transactions_sum_cents
  #-----------------------callbacks-------------------#
  def update_events_balance
    update_column :event_expences_sum, (events.map(&:event_due_price).sum)
    update_column :balance, (transactions_sum - event_expences_sum)
  end

  def update_transactions_sum
    update_column :transactions_sum, (transactions.map(&:amount).sum)
    update_column :balance, (transactions_sum - event_expences_sum)
  end
  #-----------------------scopes-------------------#
  scope :debtors, -> { where("balance < ?", 0) }
  scope :no_gender, -> { where(gender: "undisclosed") }
  scope :bday_today, -> { where("EXTRACT(DOY FROM date_of_birth) = ?", Time.zone.now.yday) }
  scope :no_events, -> { left_outer_joins(:events).where(events: { id: nil }) }
  scope :untagged, -> { left_outer_joins(:client_tags).where(client_tags: { id: nil }) }
  #scope :no_future_events, -> {joins(:events).where.not('events.starts_at >=?', Time.zone.now).distinct }
  #-----------------------lead_source options--------------------------------#
  SOURCES = [:direct, :online_booking, :referral, :website, :instagram, :facebook, :viber, :telegram, :whatsapp, :import, :other]
  def self.lead_sources
    #SOURCES.map {|source| [source.to_s.humanize, source]}
    SOURCES.map {|source| [I18n.t(source, scope: [:activerecord, :attributes, :client, :lead_sources]).capitalize, source]}
  end
  #-----------------------scope_tag_checks-------------------#
  def no_gender?
    self.gender == "undisclosed"
  end
  
  def debtors?
    self.balance < 0
  end
  #-----------------------last and next event-------------------#
  def next_event
    events.where("starts_at >= ?", Time.zone.now).order("starts_at ASC").pluck(:starts_at).first
  end
  def last_event
    events.where("starts_at <= ?", Time.zone.now).order("starts_at DESC").pluck(:starts_at).first
  end
  def average_confirmed_check
    if events_count != 0
      event_expences_sum/events_count/100.to_d
    end
  end
  
  def full_name_with_code
    full_name + " " + code.to_s
  end
end