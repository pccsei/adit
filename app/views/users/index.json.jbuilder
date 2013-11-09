json.array!(@users) do |user|
  json.extract! user, :id :name, :school_id, :role, :section, :parent_id, :email, :extension
  json.url user_url(user, format: :json)
end
