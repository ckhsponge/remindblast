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
  
  def validate
    errors.add "start_time","Reminder time must be in the future!" if !self.start_time || Time.now+1.minutes>self.start_time
    errors.add "message","Message is not specified." if self.message.blank? || (self.message==OTHER && self.custom_message.blank?)
    errors.add "destination","Number or email must be specified" if self.mobile_number.blank? && self.email.blank?
  end
end