class Profiles < ActiveRecord::Migration
  def self.up
     create_table :profiles do |t|
      t.string "title", :null => false
      t.string "short_description"
      t.text "description"
      t.text "address"
      t.text "phones"
      t.string "url"
      t.string "website"
      t.string "facebook_url"
      t.string "contact_email"
      t.string "mail_subject"
      t.text "mail_body"
      t.string "logo_file_name"
      t.string "logo_content_type"
      t.integer "logo_file_size"
      t.string "image_file_name"
      t.string "image_content_type"
      t.integer "image_file_size"
      t.string "gallery_title"
      t.timestamps
      end
  end

  def self.down
    drop_table :profiles
  end

end
