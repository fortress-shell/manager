if @projects
  json.projects @projects do |p|
    json.id p.id
    json.name p.repository_name
    json.owner p.repository_owner
    if p.builds.size
      json.builds p.builds.order(created_at: :asc).limit(1) do |b|
        json.status b.status
        json.updated_at b.updated_at
      end
    else
      json.builds []
    end
  end
else
  json.projects []
end
