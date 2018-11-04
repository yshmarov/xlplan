class Person < ApplicationRecord

  #has_one :user, inverse_of: :member
  scope :has_account, -> { includes(:users).where.not(users: {person_id: nil}) }
  has_one :user
  has_one :employee
  has_one :client

  validates :first_name, :last_name, :status, presence: true
  validates :email, uniqueness: true

  enum status: [:"Active", :"Inactive"]

  def to_s
    last_name.capitalize + " " + first_name.capitalize
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