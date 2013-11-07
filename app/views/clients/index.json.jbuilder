json.array!(@clients) do |client|
  json.extract! client, :id, :business_name, :address, :email, :website, :contact_name, :telephone, :comment, :created_at, :updated_at
  json.url client_url(client, format: :json)
end
