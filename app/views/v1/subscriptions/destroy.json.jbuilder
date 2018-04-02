if @destroy_subscription.success?
  json.success true
  json.errors nil
else
  json.success false
  json.errors @destroy_subscription.errors
end
