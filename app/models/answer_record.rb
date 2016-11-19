class AnswerRecord < ApplicationRecord
  belongs_to :user
  # validates :user_id, presence: true
  # validates :answer_id, presence: true
end
