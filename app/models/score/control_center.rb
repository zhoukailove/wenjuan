class Score::ControlCenter < ApplicationRecord
  scope :is_status, -> { first }
end
