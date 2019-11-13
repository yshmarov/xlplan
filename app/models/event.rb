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
  def to_s
    if client_id.present? && workplace_id.present?
      client.full_name.to_s + "/" + workplace.to_s + "/" + starts_at.to_s
    else
      id
    end
  end
  #-----------------------relationships-------------------#
  has_many_attached :files
  belongs_to :client, counter_cache: true
  belongs_to :workplace
  has_many :jobs, inverse_of: :event, dependent: :destroy
  has_many :services, through: :jobs
  has_many :members, through: :jobs
  has_many :users, through: :members  #for event_mailer send_email_to_members
  has_many :inbound_payments, as: :payable
  accepts_nested_attributes_for :jobs, reject_if: :all_blank, allow_destroy: true
  #-----------------------validation-------------------#
  validates :client, :workplace, :starts_at, :duration, :ends_at, :status, :status_color, :event_price, presence: true
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
  #-----------------------gem money-------------------#
  monetize :event_price, as: :event_price_cents
  monetize :event_due_price, as: :event_due_price_cents
  #-----------------------description for mailing-------------------#
  def sms_text
    services = self.services.pluck(:name).join(', ')
    time = self.starts_at.strftime("%A %d/%b/%Y %H:%M").to_s
    location = self.workplace.location.to_s
    phone = self.workplace.location.phone_number.to_s
    address = self.workplace.location.address_line.to_s
    services + " " + time + " " + location + " " + phone + " " + address 
    #services + " " + time + " " + location + " " + phone + " " + address + "XLPLAN.com" 
  end
  #-----------------------callbacks-------------------#
  #update_status_color OK
  after_update do
    if planned?
      update_column :status_color, ('blue')
    elsif confirmed? || no_show_refunded?
      update_column :status_color, ('green')
    else
      update_column :status_color, ('red')
    end
  end

  #EVENT DURATION. Default is not set in database = good because this way I can always change default duration?
  before_validation do
    self.ends_at = starts_at + 30*60
  end
  #update_duration OK
  after_save do
    if jobs.any?
      update_column :duration, (jobs.map(&:service_duration).sum)
      update_column :ends_at, (starts_at + duration*60)
    else
      update_column :ends_at, (starts_at + 30*60) #event without jobs is 30 min by default
    end
  end

  after_save :update_event_price
  def update_event_price
    update_column :event_price, (jobs.map(&:client_price).sum)
  end

  after_update :update_other_prices
  def update_other_prices
    if id?
	    if jobs.any?
	    	#event_due_price & member_due_price for member.balance
				jobs.each do |job| job.update_due_prices end
        members.each do |member| member.update_jobs_balance end
				#event_due_price is used to calculate client.balance
      	if confirmed? || no_show_refunded?
	        update_column :event_due_price, (jobs.map(&:client_price).sum)
		    else
	        update_column :event_due_price, (0)
		    end
        client.update_events_balance
	    end
    end
  end
end