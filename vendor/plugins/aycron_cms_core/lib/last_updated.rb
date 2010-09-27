# todo: make it as an act_as_last_updated plugin

# only to be used if LAST_UPDATED_ACTIVE constant is set to true
if not defined?(LAST_UPDATED_ACTIVE)
  RAILS_DEFAULT_LOGGER.info "LastUpdated not loaded as configuration was not found."
  puts "LastUpdated not loaded as configuration was not found."
else

  if LAST_UPDATED_ACTIVE

    module LastUpdated
    
      # Invoked when "include LastUpdated" is called in base_class.
      def self.append_features(base_class)
    
        base_class.before_save { |model| 
          # add last update info
          model.saveLastUpdatedDate
        }
    
        base_class.before_destroy { |model| 
          # add last update info
          model.saveLastUpdatedDate
        }
    
      end
    
    end
    
    
    #this could be in the /config/environment (and the above code on /lib/last_updated.rb)
    #require 'last_updated'
    class ActiveRecord::Base
      include LastUpdated
      
      def saveLastUpdatedDate
        # add last update info
        if self.is_a? Option and self.key == LAST_UPDATED_DATE
          # Modifying LAST_UPDATED_DATE. Stop the self cycling
        else
          format = ActiveSupport::CoreExtensions::Date::Conversions::DATE_FORMATS[:default] || "%m/%d/%Y"
          #format = ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS[:default] || "%m/%d/%Y %I:%M %p"
    
          lastUpdatedDate = Option.find_by_key(LAST_UPDATED_DATE)
          if lastUpdatedDate == nil
            lastUpdatedDate = Option.new(:key => LAST_UPDATED_DATE, 
                :option_type => STRING_OPTION_TYPE, 
                :description => "Site's last updated date.",
                :value => Time.now.strftime(format))
          else
            lastUpdatedDate.value = Time.now.strftime(format)
          end
          lastUpdatedDate.save
        end
      end
    
    end

  end

end