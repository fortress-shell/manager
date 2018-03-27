if @command.success?
  json.success true
  json.errors []
else
  json.success false
  json.errors @command.errors
end
