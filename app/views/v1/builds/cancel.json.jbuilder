if @cancel_build.success?
  json.build @build
else
  json.build nil
end
