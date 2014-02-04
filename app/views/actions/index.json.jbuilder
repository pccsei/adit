json.array!(@actions) do |action|
  json.extract! action, :id
  json.url action_url(action, format: :json)
end
