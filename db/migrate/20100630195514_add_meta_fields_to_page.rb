class AddMetaFieldsToPage < ActiveRecord::Migration
  def self.up
    add_column :pages, :meta_description, :string
    add_column :pages, :meta_keywords, :string
    add_column :pages, :meta_verify_v1, :string
    
    add_column :profiles, :meta_description, :string
    add_column :profiles, :meta_keywords, :string
    add_column :profiles, :meta_verify_v1, :string
  end

  def self.down
    remove_columns :pages, :meta_description, :meta_keywords, :meta_verify_v1
    remove_columns :profiles, :meta_description, :meta_keywords, :meta_verify_v1
  end
end
