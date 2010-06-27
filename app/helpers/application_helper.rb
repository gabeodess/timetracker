# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def strip_and_format(text)
    return simple_format(strip_tags(text))
  end
  
  def cname
    controller.controller_name
  end
  
  def aname
    controller.action_name
  end
  
end
