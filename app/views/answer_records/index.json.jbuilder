json.array!(@answer_records) do |answer_record|
  json.extract! answer_record, :id, :user_id, :answer_id, :time_cost, :status, :state
  json.url answer_record_url(answer_record, format: :json)
end
