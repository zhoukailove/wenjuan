class User < ApplicationRecord
  has_many :answer_records
  validates :name, presence: true
end
