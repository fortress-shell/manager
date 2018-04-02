if @create_subscription.success?
  json.success true
  json.errors nil
else
  json.success false
  json.errors @create_subscription.errors
end
