class RemindblastController < ApplicationController
  before_filter :init_token
  USER_NAME = ENV['USER_NAME']
  PASSWORD = ENV['PASSWORD']
  CALENDAR_ID = ENV['CALENDAR_ID']
  
  TIME_ZONES = Sponger::TimeZone::HUMAN_NAMES
  
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
    'Cut your toenails and get a haircut.',
    'Other'
  ]
  
  SPONSOR_URL = "http://spongecell.com"
  
  def index
    @reminder = ::Reminder.new(:start_time => Time.now + 5.minutes,:time_zone=>cookies[:time_zone])
    session[:time_out] = Time.now
    @hide_go_back_link = true
  end
  
  def save
    begin
      message = params[:reminder][:message]
      message = params[:reminder][:custom_message] unless params[:reminder][:custom_message].empty?
      description = title = message
      description = "Hey #{params[:reminder][:name]}, #{title}" unless params[:reminder][:name].empty?
      start_time = parse_time(params[:reminder],:start_time)
      @reminder = ::Reminder.new
      @reminder.start_time = start_time
      @reminder.load(params[:reminder])
      @reminder.validate
      unless @reminder.valid?
        render :action=>"index"
        return
      end
      cookies[:time_zone] = { :value => @reminder.time_zone, :expires => 6.months.from_now }
      unless session[:time_out] && Time.now<session[:time_out]+5.minutes
        session[:time_out] = Time.now
        raise "Time out"
      end
      
      @event = Sponger::Event.new
      @event.title = title
      @event.description = description
      @event.start_time = start_time
      @event.end_time = start_time + 1.minutes
      @event.tzid = Sponger::TimeZone.tzid_from_human(params[:reminder][:time_zone])
      @event.all_day = false
      @event.calendar_id = CALENDAR_ID
      @event.save
      
      @reminder.load(:event_id=>@event.id,:minutes_before=>0)
      @reminder.save
      #flash.now[:note] = "Reminder saved."
      @success = true
      render :action=>"list"
    rescue Exception=>exc
      flash.now[:note] = "An error has occurred: #{exc.to_s}"
      render :action=>"index"
    end
  end

  def init_token
    #Sponger::Resource.clear_private_data
    #@signed_in = !!session[:spongewolf_token]
    if !Sponger::Resource.token || Time.now > Sponger::Resource.token.expires_at
      token = Sponger::AuthorizationToken.create(:user_name=>USER_NAME,:password=>PASSWORD)
      token.expires_at = Time.now + 30.minutes
      Sponger::Resource.token = token
    end
  end
  
end
