# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'aedf644b29edde7d0ab5858256307fd8'
  
  def parse_time(params,key)
    key = key.to_s
    Time.local(params.delete("#{key}(1i)"),params.delete("#{key}(2i)"),params.delete("#{key}(3i)"),
      params.delete("#{key}(4i)"),params.delete("#{key}(5i)"))
  end
  
  def parse_date(s)
    pd = ParseDate.parsedate(s)[0,3]
    return nil unless pd && pd[0] && pd[1] && pd[2]
    Date.new(*pd)
  end
end
