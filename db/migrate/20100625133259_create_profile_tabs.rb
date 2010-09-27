class CreateProfileTabs < ActiveRecord::Migration
  def self.up
    create_table :profile_tabs do |t|
      t.integer :profile_id
      t.integer :position
      t.string :name
      t.string :tab_type
      t.string :video_url
      t.text :content
      t.timestamps
    end
  end

  def self.down
    drop_table :profile_tabs
  end
end
