class OperatingHour < ActiveRecord::Base
  #-----------------------gem milia-------------------#
  acts_as_tenant

  belongs_to :location

  #def day_of_week
    #Date::DAY_NAMES[read_attribute(:day_of_week)]
    #Date::DAYNAMES[day_of_week.wday]
  #end
  
  # If you want to set the day of week value with a string
  #def day_of_week=(value)
  #  day = Date::DAY_NAMES.index(value)
  #  write_attribute(:day_of_week, day) if day.present?
  #end

  validates_uniqueness_of :day_of_week, scope: [:location_id, :tenant_id] #this way 1 day of week can be used 1 time for 1 location
  validates_presence_of :day_of_week, :closes, :opens, :location
  validates_inclusion_of :day_of_week, :in => 0..6
  validate :opens_before_closes 
  validate :valid_from_before_valid_through 

  # sample validation for better user feedback
  validates_uniqueness_of :opens, scope: [:location_id, :day_of_week]
  validates_uniqueness_of :closes, scope: [:location_id, :day_of_week]

  protected
  def opens_before_closes
    errors.add(:closes, I18n.t('errors.opens_before_closes')) if opens && closes && opens >= closes
  end

  def valid_from_before_valid_through
    errors.add(:valid_through, I18n.t('errors.valid_from_before_valid_through')) if valid_from && valid_through && valid_from >= valid_through
  end
  
end