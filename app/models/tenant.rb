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
  validates :name, :plan, :default_currency, :locale, :industry, :time_zone, presence: true
  #validates :subdomain, presence: true, uniqueness: true, case_sensitive: false,
  #  length: { in: 3..100 }, 
  #  format: {with: %r{\A[a-z](?:[a-z0-9-]*[a-z0-9])?\z}i, message: "not a valid subdomain"},
  #  exclusion: { in: %w(app apps dashboard support blog billing help api www host admin), message: "%{value} is reserved." }
  #validates :subdomain, format: { with: /\A[\w\-]+\Z/i, message: "not a valid subdomain" }
  before_create do
    def generate_token
      loop do
        require 'securerandom' 
        token = SecureRandom.hex(10)
        break token unless Tenant.where(subdomain: token).exists?
      end
      self.subdomain = generate_token.try(:downcase)
    end
  end

  validates :name, uniqueness: true, length: { maximum: 40 } #in schema it is 40, but 20 is better
  validates :description, length: { maximum: 500 }
  validates :plan, length: { maximum: 10 }, inclusion: %w(demo blocked solo mini max) #in schema it is 40, but 10 is better
  validates :industry, length: { maximum: 144 }
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
    (plan == 'solo' && locations.count < 1) || (plan == 'mini' && locations.count < 1) || (plan == 'max') || (plan == 'demo')
  end
  def can_create_members?
    (plan == 'solo' && members.count < 1) || (plan == 'mini' && members.count < 5) || (plan == 'max') || (plan == 'demo')
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
  def self.new_signups_not_permitted?(params)
    return false
  end
  # ------------------------------------------------------------------------
  def self.tenant_signup(user, tenant, other = nil)
    Role.create!(name: "manager") #initially only admin and specialist are created.
    Tag.create!(name: "potential")
    Tag.create!(name: "contact_required")
    Tag.create!(name: "regular")
    Tag.create!(name: "VIP")
    Tag.create!(name: "lost_client")
    Tag.create!(name: "blacklist")
    Location.create!(name: tenant.name)
    Location.first.workplaces.create(name: "Studio-1")
    CashAccount.create!(name: "Cash")
    CashAccount.create!(name: "Card")
    ServiceCategory.create!(name: "Massage")
    Service.create!(name: "Head", service_category: ServiceCategory.first, duration: 30, client_price: 10000, member_percent: 50)
    Service.create!(name: "Body", service_category: ServiceCategory.first, duration: 60, client_price: 20000, member_percent: 50)
    Client.create!(first_name: "Yaroslav", last_name: "Shmarov", email: "yshmarov@gmail.com", phone_number: "+48537628023", gender: "male")
    Member.create_org_admin(user)
    Member.first.update_attributes!(location_id: Location.first.id)
  end
end
