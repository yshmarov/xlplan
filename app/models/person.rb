class Person < ApplicationRecord

  #has_one :user, inverse_of: :member
  scope :has_account, -> { includes(:users).where.not(users: {person_id: nil}) }

  validates :first_name, :last_name, :status, presence: true
  validates :email, uniqueness: { case_sensitive: false }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, format: { with: VALID_EMAIL_REGEX }


  def username
    self.email.split(/@/).first
  end

  enum status: { inactive: 0, active: 1 }

  def to_s
    last_name.capitalize + " " + first_name.capitalize
  end

  def full_name
    last_name.capitalize + " " + first_name.capitalize
  end

  def age
    if date_of_birth.present?
      now = Time.now.utc.to_date
      now.year - date_of_birth.year - ((now.month > date_of_birth.month || (now.month == date_of_birth.month && now.day >= date_of_birth.day)) ? 0 : 1)
    end
  end

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

end