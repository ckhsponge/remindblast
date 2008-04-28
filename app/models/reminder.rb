class Reminder < Sponger::Reminder
  OTHER = 'Other'
  ATTRIBUTES = [:name, :message, :custom_message, :mobile_number, :email, :start_time, :time_zone]
#  attr_accessor :name
#  attr_accessor :message
#  attr_accessor :custom_message
#  attr_accessor :mobile_number
#  attr_accessor :email
#  attr_accessor :start_time
#  attr_accessor :time_zone

  def self.new(attributes={})
    attributes[:time_zone] ||= 'Los Angeles' 
    ATTRIBUTES.each {|a| attributes[a] ||= nil}
    super attributes
  end
  
  def start_date
    return nil unless self.start_time
    return Date.new(self.start_time.year,self.start_time.month,self.start_time.day)
  end
  
  def validate
    unless self.start_time
      errors.add "time","Invalid date or time." 
    else
      errors.add "time","Reminder time must be in the future!" if !self.start_time || Time.now+1.minutes>self.start_time
    end
    errors.add "message","Message is not specified." if self.message.blank? || (self.message==OTHER && self.custom_message.blank?)
    errors.add "destination","Number or email must be specified" if self.mobile_number.blank? && self.email.blank?
  end
end