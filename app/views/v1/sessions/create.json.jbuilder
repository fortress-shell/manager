if @authenticate_user.success?
  json.success true
  json.errors []
else
  json.success false
  json.errors @authenticate_user.errors
end
