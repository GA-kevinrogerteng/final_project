class AddAttachmentLocalPhotoToPosts < ActiveRecord::Migration
  def self.up
    change_table :posts do |t|
      t.attachment :local_photo
    end
  end

  def self.down
    drop_attached_file :posts, :local_photo
  end
end
