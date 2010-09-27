class AddGoogleAnalyticsToOptions < ActiveRecord::Migration
  def self.up
      Option.new (
        :key => "GOOGLE_ANALYTICS",
        :value => "<script></script>",
        :description => "Script for google analytics.",
        :option_type => "TEXT"
      ).save!
  end

  def self.down
      if option = Option.find_by_key("GOOGLE_ANALYTICS")
        option.destroy
      end
  end
end
