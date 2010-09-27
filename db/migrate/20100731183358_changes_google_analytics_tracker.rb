class ChangesGoogleAnalyticsTracker < ActiveRecord::Migration
  def self.up
    remove_column :profiles, :google_analytics
    add_column :profiles, :google_analytics, :string
  end

  def self.down
    remove_column :profiles, :google_analytics
    add_column :profiles, :google_analytics, :text
  end
end
