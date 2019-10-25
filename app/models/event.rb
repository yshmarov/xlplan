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
  #-----------------------relationships-------------------#
  #has_many_attached :images
  has_many_attached :files
  belongs_to :client, touch: true, counter_cache: true
  belongs_to :location, touch: true, counter_cache: true
  has_many :jobs, inverse_of: :event, dependent: :destroy
  has_many :members, through: :jobs
  has_many :users, through: :members  #for event_mailer send_email_to_members
  has_many :services, through: :jobs
  has_many :inbound_payments, as: :payable
  accepts_nested_attributes_for :jobs, reject_if: :all_blank, allow_destroy: true
  #-----------------------validation-------------------#
  validates :client, :location, :starts_at, :duration, :ends_at, :status, :status_color, :client_price, :add_amount, :add_percent, presence: true
  validates :notes, length: { maximum: 3000 }
  validates :slug, uniqueness: true
  validates :slug, uniqueness: { case_sensitive: false }
  #-----------------------enums-------------------#
  enum status: { planned: 0, confirmed: 1, member_cancelled: 2, client_cancelled: 3, no_show: 4, no_show_refunded: 5}
  #-----------------------scopes-------------------#
  scope :created_today, -> { where(created_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day) }
  scope :today, -> { where(starts_at: Time.zone.now.beginning_of_day..Time.zone.now.end_of_day) }
  scope :tomorrow, -> { where(starts_at: Time.zone.now.tomorrow.beginning_of_day..Time.zone.now.tomorrow.end_of_day) }
  scope :today_and_tomorrow, -> { where(starts_at: Time.zone.now.beginning_of_day..Time.zone.now.tomorrow.end_of_day) }
  scope :close, -> { where("starts_at < ?", Time.zone.now+15.minutes).where(status: 'planned') }
  scope :is_upcoming, -> { where("starts_at > ?", Time.zone.now-15.minutes).where(status: 'planned') }
  scope :is_planned, -> { where(status: [:planned]) }
  scope :is_confirmed, -> { where(status: [:confirmed, :no_show_refunded]) }
  scope :is_cancelled, -> { where(status: [:no_show, :member_cancelled, :client_cancelled]) }
  scope :is_confirmed_or_planned, -> { where(status: [:confirmed, :planned, :no_show_refunded]) }
  #-----------------------gem rolify-------------------#
  resourcify
  after_create :add_user_ownership #for CRUD policies
  after_update :add_user_ownership
  #after_destroy :destroy_user_ownership
  #remove_role 
  def add_user_ownership
    users.distinct.each do |user|
      user.add_role(:owner, self) unless user.has_role?(:owner, self)
    end
  end

  after_destroy :remove_user_ownership
  def remove_user_ownership
    users.distinct.each do |user|
      if user.has_role?(:owner, self)
        user.remove_role(:owner, self) 
      end
    end
  end
  #-----------------------callbacks-------------------#
  after_update :update_status_color
  #after_save :update_status_color

  after_create :update_ends_at_and_client_price_and_due_prices
  after_update :update_ends_at_and_client_price_and_due_prices
  #after_save :update_ends_at_and_client_price_and_due_prices
  after_touch :update_ends_at_and_client_price_and_due_prices

  after_update :update_event_due_price
  #after_save :update_event_due_price
  after_touch :update_event_due_price

  before_validation do
    self.ends_at = starts_at + 30*60
  end

  after_create :touch_associations
  after_save :touch_associations

  #-----------------------gem money-------------------#
  monetize :client_price, as: :client_price_cents
  monetize :event_due_price, as: :event_due_price_cents
  ############GEM VALIDATES_TIMELINESS############
  #validates_date :starts_at, :on => :create, :on_or_after => :today # See Restriction Shorthand.
  #validates_date :starts_at, :on_or_after => lambda { Date.current }
  #validates :starts_at, :timeliness => {:on_or_after => lambda { Date.current }, :type => :date}

  ################

  def to_s
    #"#{service} for #{client} at #{starts_at}"
    if client.present? && location.present?
      client.full_name.to_s + "/" + location.to_s + "/" + starts_at.to_s
    else
      id
    end
  end
  
  def sms_text
    services = self.services.pluck(:name).join(', ')
    time = self.starts_at.strftime("%A %d/%b/%Y %H:%M").to_s
    location = self.location.to_s
    phone = self.location.phone_number.to_s
    address = self.location.address_line.to_s
    services + " " + time + " " + location + " " + phone + " " + address + "XLPLAN.com" 
  end

  ################

  def update_client_price
    update_column :client_price, (jobs.map(&:client_price).sum)
  end

  def update_event_due_price
    if id?
      if confirmed? || no_show_refunded?
        #update_column :event_due_price, (client_price)
        update_column :event_due_price, (client_price + client_price*add_percent/100 + add_amount*100)
      else
        update_column :event_due_price, (0)
      end
    end
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
      update_column :status_color, ('green')
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
