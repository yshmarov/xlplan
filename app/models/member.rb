class Member < ApplicationRecord
  acts_as_tenant
   
  belongs_to :user
  belongs_to :location, optional: true
  has_many :jobs, dependent: :restrict_with_error
  has_many :skills, dependent: :destroy
  has_many :comments
  has_many :service_categories, through: :skills

  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }
  include Personable

  validates :user_id, presence: true
  validates :user_id, uniqueness: true
  validates :first_name, length: { maximum: 144 }
  validates :last_name, length: { maximum: 144 }
  validates :first_name, :last_name, :status, presence: true
  #validates :email, uniqueness: { case_sensitive: false }
  #VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  #validates :email, format: { with: VALID_EMAIL_REGEX }

  monetize :balance, as: :balance_cents
  after_touch :update_balance
  enum status: { inactive: 0, active: 1 }

  DEFAULT_ADMIN = {
    first_name: "Admin",
    last_name:  "Please edit me"
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
