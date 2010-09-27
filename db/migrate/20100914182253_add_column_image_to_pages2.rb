class AddColumnImageToPages2 < ActiveRecord::Migration
  def self.up
    add_column :pages, :photo_file_name, :string

  end

  def self.down
    remove_column :pages, :photo_file_name
    remove_column :pages, :photo_content_type
    remove_column :pages, :photo_file_size
    remove_column :pages, :photo_updated_at
  end
end
