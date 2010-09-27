class CreateMarkers < ActiveRecord::Migration
  def self.up
    create_table :markers do |t|
      t.integer :profile_id
      t.column :lat, :decimal, :precision => 15, :scale => 10
      t.column :lng, :decimal, :precision => 15, :scale => 10
    end
  end

  def self.down
    drop_table :markers
  end
end
