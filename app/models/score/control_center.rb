class Score::ControlCenter < ApplicationRecord

  has_attached_file :avatar

  validates_attachment_content_type :avatar, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif", "application/pdf"]

  scope :is_status, -> { first }
end
