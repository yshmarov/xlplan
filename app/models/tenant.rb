class Tenant < ApplicationRecord
  acts_as_universal_and_determines_tenant

  has_many :members, dependent: :destroy
  has_many :clients, dependent: :destroy
  has_many :skills, dependent: :destroy
  has_many :service_categories, dependent: :destroy
  has_many :services, dependent: :destroy
  has_many :locations, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :jobs, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :inbound_payments, dependent: :destroy

  validates_presence_of :name, :plan, :industry, :default_currency, :locale
  validates_uniqueness_of :name
  validates :name, length: { maximum: 40 }
  validates :plan, length: { maximum: 40 }
  validates :default_currency, length: { maximum: 40 }
  validates :locale, length: { maximum: 2 }
  validates :industry, length: { maximum: 60 }

  def can_create_locations?
    (plan == 'free' && locations.count < 1) || (plan == 'premium')
  end

  def can_create_members?
    (plan == 'free' && members.count < 1) || (plan == 'premium')
  end

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
