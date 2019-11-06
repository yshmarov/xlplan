class Member < ApplicationRecord
  include Personable
  #-----------------------gem milia-------------------#
  acts_as_tenant
  #-----------------------relationships-------------------#
  has_one_attached :avatar
  #belongs_to :user, required: false
  belongs_to :user, required: false
  belongs_to :location, optional: true, counter_cache: true
  has_many :jobs, dependent: :restrict_with_error
  has_many :events, through: :jobs
  has_many :skills, dependent: :destroy, inverse_of: :member
  has_many :comments
  has_many :service_categories, through: :skills
  has_many :expences, as: :expendable
  has_many :leads, dependent: :restrict_with_error
  #-----------------------gem public_activity-------------------#
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }
  tracked tenant_id: Proc.new{ Tenant.current_tenant.id }
  #-----------------------gem friendly_id-------------------#
  extend FriendlyId
  friendly_id :full_name, use: :slugged
  #-----------------------validation-------------------#
  #validates :user_id, presence: true
  validates :user_id, uniqueness: true, allow_blank: true
  validates :first_name, :last_name, presence: true
  validates :first_name, :last_name, length: { maximum: 144 }
  validates :email, :phone_number, length: { maximum: 255 }
  validates :first_name, :last_name, presence: true
  validates :slug, uniqueness: true
  validates :slug, uniqueness: { case_sensitive: false }
  validates :gender, inclusion: %w(male female undisclosed)
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  #-----------------------serialization-------------------#
  serialize :address
  def address_line
    if address.present?
      [address[:country], address[:city], address[:street], address[:zip]].join(', ')
    end
  end
  #-----------------------money gem-------------------#
  monetize :jobs_due_price_sum, as: :jobs_due_price_sum_cents
  monetize :expences_amount_sum, as: :expences_amount_sum_cents
  monetize :balance, as: :balance_cents
  #-----------------------callbacks-------------------#
  after_create do
    self.update_attributes!(time_zone: Tenant.current_tenant.time_zone)
  end

  after_touch :update_balance

  after_create do
    #update_first_member_email
    if self.user.present?
      update_column :email, (user.email)
    end
  end

  after_save do
    #update_user_time_zone
    if user.present?
      user.update_attributes!(time_zone: self.time_zone)
    end
  end
  #-----------------------scopes-------------------#
  #next 5 bdays
  #next_bdays = (Date.today + 0.day).yday
  #@members = Member.where("EXTRACT(DOY FROM date_of_birth) >= ?", next_bdays).order('EXTRACT (DOY FROM date_of_birth) ASC').first(5)
  #@members = Member.where("EXTRACT(DOY FROM date_of_birth) >= ?", next_bdays).order(Arel.sql('EXTRACT (DOY FROM date_of_birth) ASC')).first(5)
  ##@members = Member.where("EXTRACT(DOY FROM date_of_birth) >= ?", next_bdays).order(Arel.sql "DATE(date_of_birth)").first(5)
  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :online_booking, -> { where(online_booking: true) }
  def self.active_or_id(record_id)
    where('id = ? OR (active=true)', record_id)    
  end
  ################TENANT VALIDATION#################
  validate :tenant_plan_quantity_limit
  def tenant_plan_quantity_limit
    if self.new_record?
      if tenant.plan == 'bronze'
        if tenant.members.count > 0
          errors.add(:base, "Bronze cannot have more than 1 employee. Upgrade your plan")
        end
      elsif tenant.plan == 'silver'
        if tenant.members.count > 5
          errors.add(:base, "Silver plan cannot have more than 5 employees. Upgrade your plan")
        end
      #elsif tenant.plan == 'gold'
      end
    end
  end
  ################MILIA MEMBER#################
  DEFAULT_ADMIN = {
    last_name:  "Admin",
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

  #protected
  
  def update_balance
    update_column :jobs_due_price_sum, (jobs.map(&:member_due_price).sum)
    update_column :expences_amount_sum, (expences.map(&:amount).sum)
    update_column :balance, (jobs_due_price_sum - expences_amount_sum)
  end

  def update_jobs_balance
    update_column :jobs_due_price_sum, (jobs.map(&:member_due_price).sum)
    update_column :balance, (jobs_due_price_sum - expences_amount_sum)
  end

  def update_expences_balance
    update_column :expences_amount_sum, (expences.map(&:amount).sum)
    update_column :balance, (jobs_due_price_sum - expences_amount_sum)
  end
end