if @command.success?
  json.success true
  json.errors nil
else
  json.success false
  json.errors @command.errors
end
