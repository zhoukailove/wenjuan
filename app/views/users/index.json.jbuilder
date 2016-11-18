json.array!(@users) do |user|
  json.extract! user, :id, :name, :login_name, :password, :status
  json.url user_url(user, format: :json)
end
