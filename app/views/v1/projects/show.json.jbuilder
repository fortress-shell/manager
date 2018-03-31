json.project do
  json.id @project.id
  json.name @project.repository_name
  json.owner @project.repository_owner
end
