module RemindblastHelper
  def error(s)
    return "" unless s
    "<div id='error'>Sorry, an error has occured.<br>#{h s}</div>"
  end
end