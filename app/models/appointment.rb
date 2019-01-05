class Appointment < ApplicationRecord
  acts_as_tenant

  belongs_to :tenant
  belongs_to :client
  belongs_to :member
  belongs_to :location
  has_many  :jobs

  enum status: { planned: 0, member_confirmed: 1, client_confirmed: 2,
                  not_attended: 3, member_cancelled:4, client_cancelled: 5}

  validates :client, :starts_at, :status, :location, :member, :status_color, presence: true
  #validates :client, :starts_at, :ends_at, :status, :location, :member, presence: true
  validates :description, length: { maximum: 500 }

  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }

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
  after_create :update_ends_at
  after_update :update_ends_at
  after_save :update_ends_at

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

  def update_ends_at
    if jobs.any?
      update_column :ends_at, (starts_at + job.first.service_duration*60)
    else
      update_column :ends_at, (starts_at + 30*60)
    end
  end

end
