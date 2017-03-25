# module Score
class Score::User < ApplicationRecord
  has_many :score_records, :class_name => 'Score::Record',dependent: :destroy

  has_attached_file :avatar, :styles => { :medium => "300x300>", :thumb => "100x100>" },
                    :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
end
# end
