json.array!(@score_users) do |score_user|
  json.extract! score_user, :id, :name, :status, :state
  json.url score_user_url(score_user, format: :json)
end
