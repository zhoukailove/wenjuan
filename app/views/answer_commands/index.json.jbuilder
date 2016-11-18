json.array!(@answer_commands) do |answer_command|
  json.extract! answer_command, :id, :answer_id, :begin_time, :end_time, :status
  json.url answer_command_url(answer_command, format: :json)
end
