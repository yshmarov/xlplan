class Tenant < ApplicationRecord
  #-----------------------gem milia-------------------#
  acts_as_universal_and_determines_tenant
  #-----------------------gem public_activity-------------------#
  #include PublicActivity::Model
  #tracked owner: Proc.new{ |controller, model| controller.current_user }
  #tracked tenant_id: Proc.new{ Tenant.current_tenant.id }
  #-----------------------relationships-------------------#
  has_one_attached :logo
  #has_many :activities, dependent: :destroy
  has_many :clients, dependent: :destroy
  has_many :client_tags, dependent: :destroy
  has_many :tags, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_many :jobs, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :members, dependent: :destroy
  has_many :workplaces, dependent: :destroy
  has_many :locations, dependent: :destroy
  has_many :services, dependent: :destroy
  has_many :service_categories, dependent: :destroy
  has_many :cash_accounts, dependent: :destroy
  has_many :skills, dependent: :destroy
  has_many :leads, dependent: :destroy
  has_many :roles, dependent: :destroy
  #-----------------------validation-------------------#
  validates_presence_of :name, :plan, :default_currency, :locale, :industry
  validates_uniqueness_of :name
  validates_uniqueness_of :subdomain, allow_blank: true
  validates :subdomain, length: { minimum: 3, maximum: 40 }, allow_blank: true

  validates :name, length: { maximum: 40 } #in schema it is 40, but 20 is better
  validates :description, length: { maximum: 500 }
  validates :plan, length: { maximum: 10 } #in schema it is 40, but 10 is better
  validates :industry, length: { maximum: 144 }
  validates :plan, inclusion: %w(demo bronze silver gold blocked)
  validates :default_currency, length: { maximum: 3 }
  validates :locale, length: { maximum: 2 }
  #-----------------------scopes-------------------#
  scope :online_booking, -> { where(online_booking: true) }
  scope :not_blocked, -> { where.not(plan: 'blocked') }

  ###select industry###
  INDUSTRIES = [:hair_beauty_barbershop, :cosmetology, :solarium, :tattoo_studio, :spa, :sauna,
  :private_clinic, :stomatology, :ophtalmologist, :psychologist, :veterinary_clinic, :massage,
  :car_services, :legal_consulting, :business_consulting, :field_services, :cleaning_services, :tutors,
  :other]
  def self.industries
    INDUSTRIES.map { |industry| [I18n.t(industry, scope: [:static_pages, :landing_page]), industry] }
  end

  ###plan limits###
  def can_create_locations?
    (plan == 'bronze' && locations.count < 1) || (plan == 'silver' && locations.count < 1) || (plan == 'gold') || (plan == 'demo')
  end

  def can_create_members?
    (plan == 'bronze' && members.count < 1) || (plan == 'silver' && members.count < 5) || (plan == 'gold') || (plan == 'demo')
  end

  ###milia###
  def self.create_new_tenant(tenant_params, user_params, coupon_params)

    #tenant = Tenant.new(:name => tenant_params[:name])
    tenant = Tenant.new(tenant_params)

    if new_signups_not_permitted?(coupon_params)

      raise ::Milia::Control::MaxTenantExceeded, "Sorry, new accounts not permitted at this time" 

    else 
      tenant.save    # create the tenant
    end
    return tenant
  end

  # ------------------------------------------------------------------------
  # new_signups_not_permitted? -- returns true if no further signups allowed
  # args: params from user input; might contain a special 'coupon' code
  #       used to determine whether or not to allow another signup
  # ------------------------------------------------------------------------
  def self.new_signups_not_permitted?(params)
    return false
  end

  # ------------------------------------------------------------------------
  # tenant_signup -- setup a new tenant in the system
  # CALLBACK from devise RegistrationsController (milia override)
  # AFTER user creation and current_tenant established
  # args:
  #   user  -- new user  obj
  #   tenant -- new tenant obj
  #   other  -- any other parameter string from initial request
  # ------------------------------------------------------------------------
    def self.tenant_signup(user, tenant, other = nil)
      #  StartupJob.queue_startup( tenant, user, other )
      # any special seeding required for a new organizational tenant
      #

      Member.create_org_admin(user)
      #
    end
end
