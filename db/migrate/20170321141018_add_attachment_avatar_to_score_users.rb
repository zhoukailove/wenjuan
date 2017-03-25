class AddAttachmentAvatarToScoreUsers < ActiveRecord::Migration
  def self.up
    change_table :score_users do |t|
      t.attachment :avatar
    end
  end

  def self.down
    remove_attachment :score_users, :avatar
  end
end
