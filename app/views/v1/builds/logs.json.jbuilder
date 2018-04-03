if @build.logs
  json.logs @build.logs.ordered_by_position
else
  json.logs []
end
