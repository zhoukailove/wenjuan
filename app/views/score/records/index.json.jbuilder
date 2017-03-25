json.array!(@score_records) do |score_record|
  json.extract! score_record, :id, :user_id, :number, :fraction, :status
  json.url score_record_url(score_record, format: :json)
end
