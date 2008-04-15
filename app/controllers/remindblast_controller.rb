class RemindblastController < ApplicationController
  before_filter :init_session, :only=>"save"
  USER_NAME = ENV['USER_NAME']
  PASSWORD = ENV['PASSWORD']
  CALENDAR_ID = ENV['CALENDAR_ID']
  
  TIME_ZONES = [
    'Yankee Time Zone',
    'Samoa',
    'Caracas',
    'Newfoundland',
    'Buenos Aires',
    'Mid-Atlantic',
    'Cape Verde Is.',
    'Greenwich Mean Time',
    'Pretoria',
    'Nairobi',
    'Abu Dhabi',
    'Islamabad',
    'Dhaka',
    'Bangkok',
    'Singapore',
    'Tokyo',
    'Adelaide',
    'Guam',
    'Lord Howe',
    'New Caledonia',
    'Norfolk',
    'Fiji',
    'Honolulu',
    'Anchorage',
    'Los Angeles',
    'Denver',
    'Chicago',
    'New York',
    'Auckland',
    'Sydney',
    'London',
    'Rome'
  ]
  
  MESSAGES = [
    'Take a shower, you stink!',
    'Lay off the drugs, fool!',
    'Do your damn laundry, it reeks!',
    'Wake up! Get your ass out of bed!',
    'Be sure to pay the rent!',
    'Take your insulin before bed!',
    'Go call your mother, she misses you!',
    'Your anniversary is coming!',
    'What, were you raised in a barn?',
    'Don\'t go home with your ex-girlfriend.',
    'Eat healthier, you\'re getting fat.',
    'Pick up more toilet paper, groceries, and/or birth control',
    'Sober self to future drunk self: Go home!',
    'In-laws arriving today, leave town.',
    'Leave the gun. Take the cannolis.',
    'You\'re so money, and you don\'t even know it.',
    'Cut my toenails and get a haircut.',
    'Other'
  ]
  
  SPONSOR_URL = "http://spongecell.com"
  
  def index
    
  end
  
  def save
    begin
      message = params[:remind][:message]
      message = params[:remind][:custom_message] unless params[:remind][:custom_message].empty?
      description = title = message
      description = "Hey #{params[:remind][:name]}, #{title}" unless params[:remind][:name].empty?
      start_time = parse_time(params[:remind],:start_time)
      if !start_time || Time.now+1.minutes>=start_time
        flash.now[:time] = "Reminder time must be in the future!"
        render :action=>"index"
        return
      end
      
      @event = Sponger::Event.new
      @event.title = title
      @event.description = description
      @event.start_time = start_time
      @event.end_time = start_time + 1.minutes
      @event.tzid = Sponger::TimeZone.tzid_from_human(params[:remind][:time_zone])
      @event.all_day = false
      @event.calendar_id = CALENDAR_ID
      @event.save
      
      @reminder = Sponger::Reminder.create(:event_id=>@event.id,:minutes_before=>0,:email=>params[:remind][:email],:mobile_number=>params[:remind][:mobile_number])
      #flash.now[:note] = "Reminder saved."
      render :action=>"list"
    rescue Exception=>exc
      flash.now[:note] = "An error has occurred: #{exc.to_s}"
      render :action=>"index"
    end
  end

  def init_session
    #Sponger::Resource.clear_private_data
    #@signed_in = !!session[:spongewolf_token]
    token = Sponger::AuthorizationToken.create(:user_name=>USER_NAME,:password=>PASSWORD)
    Sponger::Resource.token = token
  end
  
end
