if @maintenance_build.success?
  json.build @build
  json.user @build.user
else
  json.build nil
  json.user nil
end
