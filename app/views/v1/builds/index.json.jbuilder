if @builds
  json.builds @builds.ordered_by_created_at do |build|
    json.id build.id
    json.status build.status
    json.project_id build.project_id
    json.branch build.payload['ref'].split('/').last
    json.created_at build.created_at
    json.commit build.payload['after']
  end
else
  json.builds []
end
