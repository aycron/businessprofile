class AddSiteLinkToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :site_link_name, :string
  end

  def self.down
    remove_column :profiles, :site_link_name
  end
end
