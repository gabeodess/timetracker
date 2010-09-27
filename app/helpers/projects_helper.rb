module ProjectsHelper
  
  def project_select(projects, options = {}, ofs_options = {})
    options[:include_blank] ||= "Select A Project"
    select_tag(:project, options_for_project_select(projects, ofs_options))
  end
  
  def options_for_project_select(projects, options = {})
    options[:disabled] ||= "disabled"
    
    options_array = [["Select A Project", nil]]
    clients = projects.map(&:client).uniq
    
    clients.sort_by(&:name).each do |client|
      options_array << [client.name, 'disabled']
      projects.select{ |item| item.client.id == client.id }.each do |project|
        options_array << [project.name, project.id]
      end
    end
    
    return options_for_select(options_array, options)
  end
  
end