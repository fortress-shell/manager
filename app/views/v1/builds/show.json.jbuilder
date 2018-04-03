json.build do
  json.id @build.id
  json.status @build.status
  json.project_id @build.project_id
  json.branch @build.payload['ref'].split('/').last
  json.created_at @build.created_at
  json.commit @build.payload['after']
end
