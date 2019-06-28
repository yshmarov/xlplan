class Member < ApplicationRecord
  acts_as_tenant
   
  #belongs_to :user, required: false
  belongs_to :user, required: false
  belongs_to :location, optional: true, counter_cache: true
  has_many :jobs, dependent: :restrict_with_error
  has_many :events, through: :jobs
  has_many :skills, dependent: :destroy, inverse_of: :member
  has_many :comments
  has_many :service_categories, through: :skills
  #has_many :expences, as: :expendable

  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }
  tracked tenant_id: Proc.new{ Tenant.current_tenant.id }
  include Personable
  extend FriendlyId
  friendly_id :full_name, use: :slugged

  #validates :user_id, presence: true
  validates :user_id, uniqueness: true
  validates :first_name, :last_name, presence: true
  validates :first_name, :last_name, length: { maximum: 144 }
  validates :status, presence: true
  validates :email, :phone_number, length: { maximum: 255 }
  validates :first_name, :last_name, :status, presence: true
  validates :slug, uniqueness: true
  validates :slug, uniqueness: { case_sensitive: false }
  #validates :gender, inclusion: %w(Male Female Undisclosed male female undisclosed)
  #validates :email, uniqueness: { case_sensitive: false }
  #VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  #validates :email, format: { with: VALID_EMAIL_REGEX }

  serialize :address

  monetize :balance, as: :balance_cents

  after_update :update_user_time_zone
  after_save :update_user_time_zone
  def update_user_time_zone
    if user.present?
      user.update_attributes!(time_zone: self.time_zone)
    end
  end

  after_touch :update_balance
  #scope :active, -> { where(status: [:active]) }
  #scope :inactive, -> { where(status: [:inactive]) }
  enum status: { inactive: 0, active: 1 }
  def self.active_or_id(record_id)
    where('id = ? OR (status=1)', record_id)    
  end

  #####STATS#####
  def planned_work_hours
    jobs.joins(:event).where(events: {status: 'planned'}).map(&:service_duration).sum/60.to_d
  end
  def confirmed_work_hours
    jobs.joins(:event).where(events: {status: ['confirmed']}).map(&:service_duration).sum/60.to_d
  end
  def cancelled_work_hours
    jobs.joins(:event).where(events: {status: ['client_cancelled', 'member_cancelled', 'no_show']}).map(&:service_duration).sum/60.to_d
  end
  #####
  def planned_salary
    jobs.joins(:event).where(events: {status: 'planned'}).map(&:member_price).sum
  end
  def confirmed_salary
    jobs.joins(:event).where(events: {status: ['confirmed']}).map(&:member_due_price).sum
  end
  def cancelled_salary
    jobs.joins(:event).where(events: {status: ['client_cancelled', 'member_cancelled', 'no_show']}).map(&:member_due_price).sum
  end

  def planned_revenue
    jobs.joins(:event).where(events: {status: 'planned'}).map(&:client_price).sum
  end
  def confirmed_revenue
    jobs.joins(:event).where(events: {status: ['confirmed']}).map(&:client_due_price).sum
  end
  def cancelled_revenue
    jobs.joins(:event).where(events: {status: ['client_cancelled', 'member_cancelled', 'no_show']}).map(&:client_price).sum
  end

  def planned_jobs_count
    jobs.joins(:event).where(events: {status: 'planned'}).count
  end
  def confirmed_jobs_count
    jobs.joins(:event).where(events: {status: ['confirmed']}).count
  end
  def cancelled_jobs_count
    jobs.joins(:event).where(events: {status: ['client_cancelled', 'member_cancelled', 'no_show']}).count
  end

  def share_of_revenue
    def total_revenue
      Job.joins(:event).where(events: {status: ['confirmed']}).map(&:client_due_price).sum.to_d
    end
    (confirmed_revenue.to_d / total_revenue)*100
  end

  def average_service_price
    confirmed_revenue/confirmed_jobs_count/100.to_d
  end
  def cost_per_hour
    confirmed_revenue/confirmed_work_hours/100.to_d
  end

  ################

  validate :tenant_plan_quantity_limit
  def tenant_plan_quantity_limit
    if self.new_record?
      if tenant.plan == 'bronze' || tenant.plan == 'demo'
        if tenant.members.count > 1
          errors.add(:base, "Bronze plan cannot have more than 1 employee. Upgrade your plan")
        end
      elsif tenant.plan == 'silver'
        if tenant.members.count > 4
          errors.add(:base, "Silver plan cannot have more than 5 employees. Upgrade your plan")
        end
      #elsif tenant.plan == 'gold'
      end
    end
  end

  DEFAULT_ADMIN = {
    last_name:  "Organisation",
    first_name: "Admin"
  }

  def self.create_new_member(user, params)
    # add any other initialization for a new member
    return user.create_member( params )
  end

  def self.create_org_admin(user)
    new_member = create_new_member(user, DEFAULT_ADMIN)
    unless new_member.errors.empty?
      raise ArgumentError, new_member.errors.full_messages.uniq.join(", ")
    end
    return new_member
  end

  ransacker :full_name do |parent|
    Arel::Nodes::InfixOperation.new('||',
      Arel::Nodes::InfixOperation.new('||',
        parent.table[:first_name], Arel::Nodes.build_quoted(' ')
      ),
      parent.table[:last_name]
    )
  end

  #protected

  def update_balance
    update_column :balance, (jobs.map(&:member_due_price).sum)
  end

end
