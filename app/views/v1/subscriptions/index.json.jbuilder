if @view_subscriptions.success?
  json.subscriptions @view_subscriptions.result.map(&:to_h)
else
  json.errors @view_subscriptions.errors
end
