module RemindblastHelper
  def error(s)
    return "" unless s
    "<div id='error'>Sorry, an error has occured.<br>#{h s}</div>"
  end
  
  def go_back_link
    link_to "<- Go Back","/"
  end
  
  def fmt_date(d)
    return "" unless d
    "#{d.mon}/#{d.day}/#{d.year}"
  end
  

end    #
  # there are few ways to rid yourself of rails' insistence that datetime
  # selects use 24 hr time - but this is a simple one.  just drop this code into
  # ./app/helpers/application_helper.rb and your entire app will use am/pm in
  # the selects.  note that the method still posts exactly the same values (24
  # hr time) so you don't have to change a line of controller code to accept the
  # values posted.
  #
  
  module ActionView
    module Helpers
      module DateHelper
        def select_hour(datetime, options = {})
          val = datetime ? (datetime.kind_of?(Fixnum) ? datetime : datetime.hour) : ''
          if options[:use_hidden]
            hidden_html(options[:field_name] || 'hour', val, options)
          else
            hour_options = []
            0.upto(23) do |hour|
              unit = hour < 12 ? :am : :pm
              selected = "selected='selected'" if val == hour
              value =  hour
              hr = ( unit == :am ? hour : (hour - 12) )
              hr = '12' if hr == '00' || hr == '0' || hr == 0
              #hr = hr.to_s.gsub("0"," ")
              hour_options << %(<option value="#{ value }" #{ selected }>#{ hr }#{ unit }</option>\n)
            end
            select_html(options[:field_name] || 'hour', hour_options, options)
          end
        end
      end
    end
  end