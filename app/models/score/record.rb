class Score::Record < ApplicationRecord
  belongs_to :score_control, :class_name => 'Score::Control',:foreign_key => 'control_id'
  belongs_to :score_user, :class_name => 'Score::User' ,:foreign_key => 'user_id'
end
