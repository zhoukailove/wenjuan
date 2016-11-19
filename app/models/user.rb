class User < ApplicationRecord
  before_save { self.login_name = login_name.downcase }
  has_many :answer_records
  validates :name, presence: true

end
