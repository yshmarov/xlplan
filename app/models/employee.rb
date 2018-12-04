class Employee < ApplicationRecord
  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }
  include Personable

  #has_one :user
  belongs_to :location
  has_one :user, dependent: :destroy
  has_many :jobs, dependent: :restrict_with_error
  has_many :skills, dependent: :destroy
  has_many :comments
  has_many :service_categories, through: :skills
  has_many :clients, dependent: :nullify

  validates :first_name, :last_name, presence: true
  validates :location_id, :status, presence: true
  validate :termination_date_cannot_be_before_employment_date
  #validates :email, uniqueness: { case_sensitive: false }
  #VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  #validates :email, format: { with: VALID_EMAIL_REGEX }
  
  monetize :balance, as: :balance_cents
  after_touch :update_balance

  enum status: { inactive: 0, active: 1 }

  #################INVITABLE##############
  #has_one :user, inverse_of: :member
  scope :has_account, -> { includes(:users).where.not(users: {person_id: nil}) }

  def account_status
    if user.present?
      if user.invitation_accepted_at?
        'Account Active. Delete account.'
      else 
        'Invitation sent. Delete invitation.'
      end
    else
      if email.present?
        'You can invite'
        #User.invite!(:email => "new_user@example.com", :name => "John Doe")
        #= simple_form_for(User.new, url: user_invitation_path) do |z|
        #  = z.input :email, input_html: {value: person.email}, as: :hidden
        #  = z.input :person_id, input_html: {value: person.id}, as: :hidden
        #  = z.button :submit, 'Invite', class: "btn btn-success btn-xs"
      else
        'Add email to invite user'
      end
    end
  end

  ransacker :full_name do |parent|
    Arel::Nodes::InfixOperation.new('||',
      Arel::Nodes::InfixOperation.new('||',
        parent.table[:first_name], Arel::Nodes.build_quoted(' ')
      ),
      parent.table[:last_name]
    )
  end

  #################INVITABLE##############
  def update_balance
    update_column :balance, (jobs.map(&:employee_due_price).sum)
  end

  def associations?
    jobs.any?
  end

  protected

  def termination_date_cannot_be_before_employment_date
    if termination_date.present? && termination_date <= employment_date
      errors.add(:termination_date, "can't be before employment date")
    end
  end

end
