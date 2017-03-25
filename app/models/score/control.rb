class Score::Control < ApplicationRecord
  has_many :score_records, :class_name => 'Score::Record' ,dependent: :destroy

end
