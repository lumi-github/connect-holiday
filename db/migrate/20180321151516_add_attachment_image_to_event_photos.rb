class AddAttachmentImageToEventPhotos < ActiveRecord::Migration
  def self.up
    change_table :event_photos do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :event_photos, :image
  end
end
