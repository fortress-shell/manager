if @build_command.result
  json.build do
    json.user_id @build_command.result.user.id
    json.id @build_command.result.id
    json.status @build_command.result.status
  end
else
  json.build nil
end
