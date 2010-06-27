module NavHelper
  
  def link_to_crud(item, options = {})
    except = [options[:except]].flatten.reject(&:nil?).map(&:to_sym)
    items = []
    items << link_to_show(item) unless except.include?(:show)
    items << link_to_edit(item) unless except.include?(:edit)
    items << link_to_destroy(item) unless except.include?(:destroy)
    
    divider = options[:divider] || ' | '
    content_tag('nobr', items.reject(&:nil?).join(divider))
  end
  
  def link_to_external(text, url = nil, options = {})
    my_url ||= text
    link_to text, 'http://' + my_url.gsub(/^\w+:/,''), options.merge(:popup => true)
  end
  
  def external_url(url, options = {})
    protocol = (pc = options[:protocol].try(:to_s).blank?) ? 'http' : pc
    "#{protocol}://" + url.gsub(/^\w+:/,'')
  end
  
  def link_to_active(text, url, args = {}, condition = false)
    args[:class] = "#{args[:class]} active" if [request.url, request.path].include?(url_for(url)) || condition
    link_to(text, url, args)
  end
  
  def link_to_controller(controller, options = {})
    controllers = ([controller] << options.delete(:include)).flatten.reject(&:nil?).map(&:to_s)
    text = options.delete(:text) || controller.to_s.titleize
    text += " (#{controller.to_s.singularize.camelcase.constantize.count})" if options[:include_count]
    url = (options.delete(:url)) || controller
    condition = (controllers.include?(cname) || request.url == url)
    link_to_active(text, url, options, condition)
  end
  
  def link_to_new(item, options = {})
    options_text = options.delete(:text)
    text = options_text || image_tag('new.png', :alt => "New #{item.to_s.titleize}", :title => "New #{item.to_s.titleize}")
    @appendage = options[:append] || "Add New #{item.to_s.titleize}" unless options[:append] == false || (options_text && !options[:append])
    link_to "#{text}#{@appendage}", send(:"new_#{item.to_s}_path", options[:item]), options
  end
  
  def link_to_edit(item, options = {})
    text = options.delete(:text) || image_tag('edit.png', :alt => 'Edit', :title => 'Edit')
    link_to text, send("edit_#{item.class.to_s.tableize.singularize}_path", item), options
  end

  def link_to_show(item, options = {})
    text = options.delete(:text) || image_tag('show.png', :alt => 'Show', :title => 'Show')
    link_to text, item, options
  end
  
  def link_to_destroy(item, options = {})
    text = options.delete(:text) || image_tag('delete.png', :alt => 'Delete', :title => 'Delete')
    options[:method] = :delete
    options[:confirm] ||= "Are you sure?"
    link_to text, item, options
  end
  alias_method :link_to_delete, :link_to_destroy
  
end