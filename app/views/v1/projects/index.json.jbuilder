if @projects
  json.projects @projects do |project|
    json.id project.id
    json.name project.repository_name
    json.owner project.repository_owner
    last_build = project.builds.last
    if last_build.nil?
      json.status nil
      json.last nil
    else
      json.status project.builds.last
      json.last project.builds.last
    end
  end
else
  json.projects []
end
