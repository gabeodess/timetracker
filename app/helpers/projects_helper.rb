module ProjectsHelper
  
  def project_select(projects, options = {}, ofs_options = {})
    options[:include_blank] ||= "Select A Project"
    ofs_options[:selected] ||= options[:selected]
    select_tag(:project, options_for_project_select(projects, ofs_options))
  end
  
  def options_for_project_select(projects, options = {})
    clients = projects.map(&:client).uniq
        
    return grouped_options_for_select(
      clients.sort_by(&:name
      ).map{ |client| [client.name, projects.select{ |project| project.client.id == client.id 
      }.map{ |project| [project.name, project.id] }] }
    )
  end
  
end