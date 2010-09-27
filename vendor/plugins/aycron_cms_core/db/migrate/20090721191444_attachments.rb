class Attachments < ActiveRecord::Migration

  def self.up
    create_table :attachments do |t|
      t.integer :size
      t.integer :height
      t.integer :width
      t.integer :parent_id
      t.string :content_type
      t.string :filename
      t.string :thumbnail

      t.string :type
      t.integer :attachable_id
      t.string :attachable_type
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :attachments
  end

end
