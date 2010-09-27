class AddActiveToProfile < ActiveRecord::Migration
  def self.up
    add_column :profiles, :active, :boolean
  end

  def self.down
    remove_column :profiles, :active
  end
end
