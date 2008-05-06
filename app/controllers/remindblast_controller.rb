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
  
  FAQ = [
    ["What can I do with RemindBlast?","RemindBlast reminds you to walk the dog, move your car for parking, and reminds your smelly friend about the importance of hygiene."],
    ["Can I use RemindBlast to spam my friends about worthless things they don't want to hear about?","No. You absolutely cannot do that."],
    ["RemindBlast is incredible. How can I pay you for this fantastic service?","Knowing that you are waking up and making it to work on time is all the payment we need."],
    ["If I have a hot date at 8pm with someone I haven't met yet what time should I set a RemindBlast for?","Set the RemindBlast for 6pm so you will have time to cut your toe nails, wax your hair and troll for alternates on craigslist in case things don't go well."],
    ["What's the difference between Neil Armstrong and Michael Jackson?","Neil Armstrong walked on the moon and Michael Jackson does weird things to... does the moon walk."],
    ["How do I find out what other people are RemindBlasting?","You can click on the RSS icon in your browser URL bar to see what other people are reminding but that's sort of creepy. Maybe you should stick to your reminders."],
    ["My girlfriend seems to be unpleasant to be around about every four weeks. Can I use RemindBlast to warn me about this?","A woman's cycle transcends any machine based predictability. Please try to be more understanding."],
    ["I hate you. Go to hell. I'm never sending another RemindBlast as long as I live.","Please try to phrase that as a question."],
    ["What should I do if I can't think of a good RemindBlast at the moment?","Set a RemindBlast for 5 minutes from now: remember to think of a good RemindBlast."]
  ]
  
  SPONSOR_URL = "http://spongecell.com/promote/website/affiliate/132211"
  RSS_URL = "http://spongecell.com/rss/events/remindblast/Remind+Blasts"
  ICAL_URL = "http://spongecell.com/ics/calendar/remindblast/Remind+Blasts.ics"
  WEBCAL_URL = "webcal://spongecell.com/ics/calendar/remindblast/Remind+Blasts.ics"
  CONTACT_EMAIL = "remindblast@spongecell.com"
  
  
  def index
    @reminder = ::Reminder.new(:start_time => Time.now + 5.minutes,:time_zone=>cookies[:time_zone])
    session[:time_out] = Time.now
    @hide_go_back_link = true
    @onload = "dataChanged()"
  end
  
  def save
    begin
      message = params[:reminder][:message]
      message = params[:reminder][:custom_message] unless params[:reminder][:custom_message].empty?
      description = title = message
      description = "Hey #{params[:reminder][:name]}, #{title}" unless params[:reminder][:name].empty?
#      start_time = parse_time(params[:reminder],:start_time)
#      start_date = parse_date(params[:reminder][:start_date])
#      if start_date
#        start_time = Time.local(start_date.year,start_date.month,start_date.day,start_time.hour,start_time.min)
#      else
#        start_time = nil
#      end
      start_time = parse_date_time("#{params[:reminder][:start_date]} #{params[:reminder][:start_time_human]}")
      @reminder = ::Reminder.new
      @reminder.start_time = start_time
      @reminder.load(params[:reminder])
      @reminder.validate
      unless @reminder.valid?
        @onload = "dataChanged()"
        render :action=>"index"
        return
      end
      cookies[:time_zone] = { :value => @reminder.time_zone, :expires => 6.months.from_now }
      unless session[:time_out] && Time.now<session[:time_out]+10.minutes
        #this is session protection so robots can't use our service
        session[:time_out] = Time.now
        raise "Time out. Please try again."
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
      @reminder = ::Reminder.new(:start_time => Time.now + 5.minutes,:time_zone=>cookies[:time_zone])
      @onload = "dataChanged()"
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
