json.array!(@updates) do |update|
  json.extract! update, 
  json.url update_url(update, format: :json)
end
