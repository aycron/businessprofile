class ChangesOnGoogleAnalytics < ActiveRecord::Migration
  def self.up
    if option = Option.find_by_key("GOOGLE_ANALYTICS")
      option.destroy
    end
    
    add_column :profiles, :google_analytics, :text
  end

  def self.down
    Option.new (
        :key => "GOOGLE_ANALYTICS",
        :value => "<script></script>",
        :description => "Script for google analytics.",
        :option_type => "TEXT"
      ).save!
      
    remove_column :profiles, :google_analytics
  end
end
