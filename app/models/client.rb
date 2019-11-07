class Client < ApplicationRecord
  include Personable
  #-----------------------gem milia-------------------#
  acts_as_tenant
  #-----------------------callbacks-------------------#
  after_touch :update_payments_balance
  #-----------------------gem public_activity-------------------#
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }
  tracked tenant_id: Proc.new{ Tenant.current_tenant.id }
  #-----------------------gem friendly_id-------------------#
  extend FriendlyId
  friendly_id :full_name, use: :slugged
  #-----------------------relationships-------------------#
  has_one_attached :avatar
  has_many :leads, dependent: :restrict_with_error
  has_many :events, dependent: :restrict_with_error
  has_many :jobs, through: :events
  has_many :services, through: :jobs
  has_many :comments, as: :commentable
  has_many :inbound_payments, dependent: :restrict_with_error
  has_one :contact, inverse_of: :client, dependent: :nullify
  has_many :client_tags, inverse_of: :client, dependent: :destroy
  has_many :tags, through: :client_tags
  #-----------------------validation-------------------#
  validates :first_name, :last_name, presence: true
  validates :first_name, :last_name, length: { maximum: 144 }
  validates :slug, uniqueness: true
  validates :slug, uniqueness: { case_sensitive: false }
  validates :gender, inclusion: %w(male female undisclosed)
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  #-----------------------serialization-------------------#
  #serialize :address, Hash
  serialize :address
  #store :address, accessors: [:street_address, :city, :state, :zip], coder: JSON
  def address_line
    if address.present?
      [address[:country], address[:city], address[:street], address[:zip]].join(', ')
    end
  end
  #-----------------------scopes-------------------#
  scope :debtors, -> { where("balance < ?", 0) }
  scope :no_gender, -> { where(gender: "undisclosed") }
  scope :bday_today, -> { where("EXTRACT(DOY FROM date_of_birth) = ?", Time.zone.now.yday) }
  scope :no_events, -> { left_outer_joins(:events).where(events: { id: nil }) }
  #scope :no_future_events, -> {joins(:events).where.not('events.starts_at >=?', Time.zone.now).distinct }
  #@clients = Client.where("EXTRACT(YEAR FROM date_of_birth) >= ?", 1948).where("EXTRACT(DOY FROM date_of_birth) = ?", Time.zone.now.yday).order(Arel.sql('EXTRACT (DOY FROM date_of_birth) ASC'))
  #@clients = Client.where("EXTRACT(YEAR FROM date_of_birth) >= ?", Date.today.year - 65).where("EXTRACT(DOY FROM date_of_birth) = ?", Time.zone.now.yday).order(Arel.sql('EXTRACT (DOY FROM date_of_birth) ASC'))
  #-----------------------money gem-------------------#
  monetize :balance, as: :balance_cents
  monetize :payments_amount_sum, as: :payments_amount_sum_cents
  monetize :jobs_amount_sum, as: :jobs_amount_sum_cents
  #-----------------------lead_source options--------------------------------#
  SOURCES = [:direct, :online_booking, :referral, :website, :instagram, :facebook, :viber, :telegram, :whatsapp, :import, :other]
  def self.lead_sources
    #SOURCES.map {|source| [source.to_s.humanize, source]}
    SOURCES.map {|source| [I18n.t(source, scope: [:activerecord, :attributes, :client, :lead_sources]).capitalize, source]}
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
      jobs_amount_sum/events_count/100.to_d
    end
  end
  #-----------------------callbacks details-------------------#
  #private
  #protected

  def update_events_balance
    update_column :jobs_amount_sum, (events.map(&:event_due_price).sum)
    update_column :balance, (payments_amount_sum - jobs_amount_sum)
  end

  def update_payments_balance
    update_column :payments_amount_sum, (inbound_payments.map(&:amount).sum)
    update_column :balance, (payments_amount_sum - jobs_amount_sum)
  end
end