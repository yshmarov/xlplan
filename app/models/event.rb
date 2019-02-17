class Event < ApplicationRecord
  acts_as_tenant
  resourcify

  belongs_to :tenant
  belongs_to :client, touch: true, counter_cache: true
  belongs_to :location, touch: true, counter_cache: true
  has_many :jobs, inverse_of: :event, dependent: :destroy
  has_many :members, through: :jobs
  has_many :services, through: :jobs

  accepts_nested_attributes_for :jobs, reject_if: :all_blank, allow_destroy: true

  enum status: { planned: 0, confirmed: 1, member_cancelled: 2, client_cancelled: 3, client_not_attended: 4}

  validates :client, :location, :starts_at, :duration, :ends_at, :status, :status_color, :client_price, presence: true
  validates :notes, length: { maximum: 500 }

  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }
  extend FriendlyId
  friendly_id :to_s, use: :slugged
  def to_s
    #"#{service} for #{client} at #{starts_at}"
    if client.present? && location.present?
      client.full_name.to_s + "/" + location.to_s + "/" + starts_at.to_s
    else
      id
    end
  end

  scope :close, -> { where("starts_at < ?", Time.zone.now+15.minutes).where(status: 'planned') }
  scope :is_upcoming, -> { where("starts_at > ?", Time.zone.now-15.minutes).where(status: 'planned') }
  scope :is_planned, -> { where(status: [:planned]) }
  scope :is_confirmed, -> { where(status: [:confirmed]) }
  scope :is_cancelled, -> { where(status: [:client_not_attended, :member_cancelled, :client_cancelled]) }
  scope :is_confirmed_or_planned, -> { where(status: [:confirmed, :planned]) }
  #rename client_not_attended to client_not_arrived?

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
    if status == 'confirmed'
      update_column :status_color, ('green')
    elsif status == 'member_cancelled' || status == 'client_cancelled' || status == 'client_not_attended'
      update_column :status_color, ('grey')
    elsif status == 'planned'
      update_column :status_color, ('blue')
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
