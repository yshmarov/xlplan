module Personable
  def to_s
    last_name.capitalize + " " + first_name.capitalize
  end

  def full_name
    [last_name, first_name].join(' ')
    #last_name.capitalize + " " + first_name.capitalize
  end

  def short_name
    if last_name.present? && first_name.present?
      last_name.capitalize + "." + first_name[0].capitalize
    end
  end

  def username
    self.email.split(/@/).first
  end
  
  def phone_number_only_digits
    self.phone_number.tr('^0-9', '')  
  end

  def user_online
    if user.present? && user.online?
      1
    end
  end

  def age
    if date_of_birth.present?
      now = Time.now.utc.to_date
      now.year - date_of_birth.year - ((now.month > date_of_birth.month || (now.month == date_of_birth.month && now.day >= date_of_birth.day)) ? 0 : 1)
    end
  end
end