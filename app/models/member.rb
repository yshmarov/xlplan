class Member < ApplicationRecord
  acts_as_tenant
   
  belongs_to :user
  belongs_to :location, optional: true
  has_many :jobs
  has_many :appointments, through: :jobs
  has_many :skills, dependent: :destroy, inverse_of: :member
  has_many :comments
  has_many :service_categories, through: :skills

  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }
  include Personable
  extend FriendlyId
  friendly_id :full_name, use: :slugged

  #accepts_nested_attributes_for :skills, reject_if: :all_blank, allow_destroy: true

  validates :user_id, presence: true
  validates :user_id, uniqueness: true
  validates :first_name, :last_name, length: { maximum: 144 }
  validates :email, :phone_number, length: { maximum: 255 }
  validates :first_name, :last_name, :status, presence: true
  #validates :email, uniqueness: { case_sensitive: false }
  #VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  #validates :email, format: { with: VALID_EMAIL_REGEX }

  serialize :address

  monetize :balance, as: :balance_cents
  after_touch :update_balance
  enum status: { inactive: 0, active: 1 }

  #####STATS#####
  def planned_work_hours
    jobs.joins(:appointment).where(appointments: {status: 'planned'}).map(&:service_duration).sum/60.to_d
  end
  def confirmed_work_hours
    jobs.joins(:appointment).where(appointments: {status: ['confirmed']}).map(&:service_duration).sum/60.to_d
  end
  def cancelled_work_hours
    jobs.joins(:appointment).where(appointments: {status: ['client_cancelled', 'member_cancelled', 'client_not_attended']}).map(&:service_duration).sum/60.to_d
  end

  def planned_payments
    jobs.joins(:appointment).where(appointments: {status: 'planned'}).map(&:client_price).sum
  end
  def confirmed_payments
    jobs.joins(:appointment).where(appointments: {status: ['confirmed']}).map(&:client_due_price).sum
  end
  def cancelled_payments
    jobs.joins(:appointment).where(appointments: {status: ['client_cancelled', 'member_cancelled', 'client_not_attended']}).map(&:client_price).sum
  end

  def planned_earnings
    jobs.joins(:appointment).where(appointments: {status: 'planned'}).map(&:member_price).sum
  end
  def confirmed_earnings
    jobs.joins(:appointment).where(appointments: {status: ['confirmed']}).map(&:member_due_price).sum
  end
  def cancelled_earnings
    jobs.joins(:appointment).where(appointments: {status: ['client_cancelled', 'member_cancelled', 'client_not_attended']}).map(&:member_price).sum
  end

  def planned_jobs_count
    jobs.joins(:appointment).where(appointments: {status: 'planned'}).count
  end
  def confirmed_jobs_count
    jobs.joins(:appointment).where(appointments: {status: ['confirmed']}).count
  end
  def cancelled_jobs_count
    jobs.joins(:appointment).where(appointments: {status: ['client_cancelled', 'member_cancelled', 'client_not_attended']}).count
  end

  def share_of_revenue
    def total_revenue
      Job.joins(:appointment).where(appointments: {status: ['confirmed']}).map(&:client_due_price).sum.to_d
    end
    (confirmed_payments.to_d / total_revenue)*100
  end

  def average_service_price
    confirmed_earnings/confirmed_jobs_count/100.to_d
  end
  def cost_per_hour
    confirmed_earnings/confirmed_work_hours/100.to_d
  end

  ################

  validate :free_plan_can_only_have_one_member
  def free_plan_can_only_have_one_member
    if self.new_record? && (tenant.members.count > 0) && (tenant.plan == 'free')
      errors.add(:base, "Free plans cannot have more than one member")
    end
  end

  DEFAULT_ADMIN = {
    last_name:  "Organization",
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

  def associations?
    jobs.any?
  end

end
