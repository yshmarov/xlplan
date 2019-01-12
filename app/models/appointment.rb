class Appointment < ApplicationRecord
  acts_as_tenant

  belongs_to :tenant
  belongs_to :client, touch: true, counter_cache: true
  belongs_to :member, touch: true, counter_cache: true
  belongs_to :location, touch: true, counter_cache: true
  has_many :jobs, inverse_of: :appointment, dependent: :destroy
  accepts_nested_attributes_for :jobs, reject_if: :all_blank, allow_destroy: true

  enum status: { planned: 0, member_confirmed: 1, client_confirmed: 2, not_attended: 3, member_cancelled:4, client_cancelled: 5}

  validates :client, :member, :location, :starts_at, :duration, :ends_at, :status, :status_color, :client_price, presence: true
  validates :description, length: { maximum: 500 }

  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }
  extend FriendlyId
  friendly_id :to_s, use: :slugged
  def to_s
    #"#{service} for #{client} at #{starts_at} by #{member}"
    client.full_name.to_s + "/" + member.full_name.to_s + "/" + location.to_s + "/" + starts_at.to_s
  end

  scope :mark_attendance, -> { where("starts_at < ?", Time.zone.now+15.minutes).where(status: 'planned') }
  scope :is_upcoming, -> { where("starts_at > ?", Time.zone.now-15.minutes).where(status: 'planned') }
  scope :is_confirmed, -> { where(status: [:member_confirmed, :client_confirmed]) }
  scope :is_cancelled, -> { where(status: [:member_cancelled, :client_cancelled]) }
  scope :did_not_happen, -> { where(status: [:not_attended, :member_cancelled, :client_cancelled]) }
  scope :is_planned, -> { where(status: [:planned]) }
  scope :is_confirmed_or_planned, -> { where(status: [:member_confirmed, :client_confirmed, :planned]) }

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

  ############GEM VALIDATES_TIMELINESS############
  #validates_time :starts_at, :between => ['9:00am', '5:00pm'] # On or after 9:00AM and on or before 5:00PM
  #validates_date :starts_at, :on => :create, :on_or_after => :today # See Restriction Shorthand.
  #validates_date :starts_at, :on_or_after => lambda { Date.current }
  #validates :starts_at, :timeliness => {:on_or_after => lambda { Date.current }, :type => :date}
  ############GEM VALIDATES_OVERLAP############
  #cancelled Jobs should not be taken in account
  #validates :starts_at, :ends_at, :overlap => {:query_options => {:is_cancelled => nil}}
  #validates :starts_at, :ends_at, overlap: {:scope => "member_id", :exclude_edges => ["starts_at", "ends_at"], :load_overlapped => true}

  #def overlapped_records
  #  @overlapped_records || []
  #end

  private

  def update_status_color
    if status == 'client_confirmed' || status == 'member_confirmed'
      update_column :status_color, ('green')
    elsif status == 'not_attended'
      update_column :status_color, ('red')
    elsif status == 'member_cancelled' || status == 'client_cancelled'
      update_column :status_color, ('grey')
    elsif status == 'planned'
      update_column :status_color, ('blue')
    else
      update_column :status_color, ('black')
    end
  end

  def touch_associations
    client.update_balance
    member.update_balance
    location.update_balance
  end

  def update_ends_at_and_client_price_and_due_prices
    if jobs.any?
      update_column :duration, (jobs.map(&:service_duration).sum)
      update_column :ends_at, (starts_at + duration*60)
      update_column :client_price, (jobs.map(&:client_due_price).sum)
      ######if I try as <unless new record>
      jobs.each do |job| job.update_due_prices end
      #job.update_due_prices
      #job.all.update_due_prices
    else
      update_column :ends_at, (starts_at + 30*60)
    end
  end

end
