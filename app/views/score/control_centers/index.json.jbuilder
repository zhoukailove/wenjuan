json.array!(@score_control_centers) do |score_control_center|
  json.extract! score_control_center, :id, :begin_time, :end_time, :fraction, :people_number, :round_number, :status
  json.url score_control_center_url(score_control_center, format: :json)
end
