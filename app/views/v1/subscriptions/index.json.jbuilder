if @command.success?
  json.subscriptions @command.result.map(&:to_h)
else
  json.errors @command.errors
end
