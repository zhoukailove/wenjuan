class AddAttachmentAvatarToScoreControlCenters < ActiveRecord::Migration
  def self.up
    change_table :score_control_centers do |t|
      t.attachment :avatar
    end
  end

  def self.down
    remove_attachment :score_control_centers, :avatar
  end
end
