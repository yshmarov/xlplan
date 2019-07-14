class Event < ApplicationRecord
  #-----------------------gem milia-------------------#
  acts_as_tenant
  #-----------------------gem public_activity-------------------#
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }
  tracked tenant_id: Proc.new{ Tenant.current_tenant.id }
  #-----------------------gem friendly_id-------------------#
  extend FriendlyId
  friendly_id :to_s, use: :slugged
  #-----------------------gem rolify-------------------#
  resourcify
  #-----------------------relationships-------------------#
  belongs_to :client, touch: true, counter_cache: true
  belongs_to :location, touch: true, counter_cache: true
  has_many :jobs, inverse_of: :event, dependent: :destroy
  has_many :members, through: :jobs
  has_many :services, through: :jobs
  has_many :inbound_payments, as: :payable
  accepts_nested_attributes_for :jobs, reject_if: :all_blank, allow_destroy: true
  #-----------------------validation-------------------#
  validates :client, :location, :starts_at, :duration, :ends_at, :status, :status_color, :client_price, presence: true
  validates :notes, length: { maximum: 500 }
  validates :slug, uniqueness: true
  validates :slug, uniqueness: { case_sensitive: false }
  #-----------------------enums-------------------#
  enum status: { planned: 0, confirmed: 1, member_cancelled: 2, client_cancelled: 3, no_show: 4, no_show_refunded: 5}
  #-----------------------scopes-------------------#
  scope :tomorrow, -> { where("starts_at > ?", Date.tomorrow).where(status: 'planned') }
  scope :close, -> { where("starts_at < ?", Time.zone.now+15.minutes).where(status: 'planned') }
  scope :is_upcoming, -> { where("starts_at > ?", Time.zone.now-15.minutes).where(status: 'planned') }
  scope :is_planned, -> { where(status: [:planned]) }
  scope :is_confirmed, -> { where(status: [:confirmed, :no_show_refunded]) }
  scope :is_cancelled, -> { where(status: [:no_show, :member_cancelled, :client_cancelled]) }
  scope :is_confirmed_or_planned, -> { where(status: [:confirmed, :planned, :no_show_refunded]) }
  #rename no_show to client_not_arrived?

  def to_s
    #"#{service} for #{client} at #{starts_at}"
    if client.present? && location.present?
      client.full_name.to_s + "/" + location.to_s + "/" + starts_at.to_s
    else
      id
    end
  end

  #-----------------------callbacks-------------------#
  after_create :update_status_color
  after_update :update_status_color
  after_save :update_status_color

  after_create :update_ends_at_and_client_price_and_due_prices
  after_update :update_ends_at_and_client_price_and_due_prices
  after_save :update_ends_at_and_client_price_and_due_prices
  after_touch :update_ends_at_and_client_price_and_due_prices

  before_validation do
    self.ends_at = starts_at + 30*60
  end

  after_create :touch_associations
  after_save :touch_associations

  #-----------------------gem money-------------------#
  monetize :client_price, as: :client_price_cents
  monetize :client_price_to_pay, as: :client_price_to_pay_cents
  ############GEM VALIDATES_TIMELINESS############
  #validates_date :starts_at, :on => :create, :on_or_after => :today # See Restriction Shorthand.
  #validates_date :starts_at, :on_or_after => lambda { Date.current }
  #validates :starts_at, :timeliness => {:on_or_after => lambda { Date.current }, :type => :date}

  def client_price_to_pay
    if confirmed?
      client_price
    else
      0
    end
  end

  def update_client_price
    update_column :client_price, (jobs.map(&:client_price).sum)
  end

  protected

  def update_status_color
    if status == 'planned'
      update_column :status_color, ('blue')
    elsif status == 'confirmed'
      update_column :status_color, ('green')
    elsif status == 'member_cancelled' || status == 'client_cancelled' || status == 'no_show'
      update_column :status_color, ('red')
    elsif status == 'no_show_refunded'
      update_column :status_color, ('yellow')
    else
      update_column :status_color, ('black')
    end
  end

  def touch_associations
    client.update_balance
    location.update_balance
    members.each do |member| member.update_balance end
  end

  def update_ends_at_and_client_price_and_due_prices
    if jobs.any?
      update_column :duration, (jobs.map(&:service_duration).sum)
      update_column :ends_at, (starts_at + duration*60)
      update_column :client_price, (jobs.map(&:client_price).sum)
      ######if I try as <unless new record>
      jobs.each do |job| job.update_due_prices end
      #job.update_due_prices
      #job.all.update_due_prices
    else
      update_column :ends_at, (starts_at + 0)
    end
  end

end
