json.array!(@users) do |user|
  json.extract! user, :id, :name, :school_id, :role, :section, :parent_id, :email, :room_number, :mobile_number, :box_number, :power_token
  json.url user_url(user, format: :json)
end
