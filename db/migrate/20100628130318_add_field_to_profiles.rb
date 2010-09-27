class AddFieldToProfiles < ActiveRecord::Migration
  def self.up
    add_column :profiles, :gallery_label, :string
  end

  def self.down
    remove_column :profiles, :gallery_label
  end
end
