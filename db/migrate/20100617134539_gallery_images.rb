class GalleryImages < ActiveRecord::Migration
  def self.up
    create_table :gallery_images do |t|
      t.integer "position"
      t.integer "profile_id"
      t.string "image_file_name"
      t.string "image_content_type"
      t.integer "image_file_size"
      t.timestamps
    end    
  end
  
  def self.down
    drop_table :gallery_images
  end
end
