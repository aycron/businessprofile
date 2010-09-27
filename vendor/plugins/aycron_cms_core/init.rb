RAILS_DEFAULT_LOGGER.info "Initializing AYCRON_CMS_CORE"
puts "Initializing AYCRON_CMS_CORE"
# load default constants
require "#{File.dirname __FILE__}/config/initializers/constants"
# load this project constants
require "#{RAILS_ROOT}/config/initializers/constants"
# load libs
Dir["#{File.dirname __FILE__}/lib/*.rb"].each { |file| require file }

# render_component
#require 'components'
ActionController::Base.send :include, Components

# Active Scaffold extensions
ActionView::Base.send(:include, AycronActiveScaffoldActionView)
ActionController::Base.send(:include, AycronActiveScaffoldActionController)
# Controller Permissions
ActionController::Base.send(:include, AycronActiveScaffoldAuthorizedActions)

# Acts As List
ActiveRecord::Base.send(:include, ActiveRecord::Acts::List)


# Rollover Beethoven
if ROLLOVER_BEETHOVEN_ACTIVE
  ActionView::Base.send :include, RolloverBeethoven
  require 'fileutils'
  # Create /public/images/auto
  directory = "#{RAILS_ROOT}/public/images/auto"
  if File.exists? directory
    RAILS_DEFAULT_LOGGER.info "RolloverBeethoven: #{directory} already exists."
    puts "RolloverBeethoven: #{directory} already exists."
  else
    RAILS_DEFAULT_LOGGER.info "RolloverBeethoven: #{directory} doesn't exist, creating..."
    puts "RolloverBeethoven: #{directory} doesn't exist, creating..."
    begin
      FileUtils.mkdir(directory)
      FileUtils.chmod(0777, directory)
      FileUtils.chown('mongrel','mongrel', directory)
      RAILS_DEFAULT_LOGGER.info "RolloverBeethoven: #{directory} created."
      puts "RolloverBeethoven: #{directory} created."
    rescue
      RAILS_DEFAULT_LOGGER.info "RolloverBeethoven: WARNING: couldn't create #{directory}."
      puts "RolloverBeethoven: WARNING: couldn't create #{directory}."
    end
  end
end

# ************************************************************
# ************** fckEditor ***********************************
# ************************************************************
#require 'fckeditor'
#require 'fckeditor_version'
#require 'fckeditor_file_utils'

#FckeditorFileUtils.check_and_install

# make plugin controller available to app
#config.load_paths += %W(#{Fckeditor::PLUGIN_CONTROLLER_PATH} #{Fckeditor::PLUGIN_HELPER_PATH})

#Rails::Initializer.run(:set_load_path, config)

ActionView::Base.send(:include, Fckeditor::Helper)

# require the controller
#require 'fckeditor_controller'

# add a route for spellcheck
#class ActionController::Routing::RouteSet
#  unless (instance_methods.include?('draw_with_fckeditor'))
#    class_eval <<-"end_eval", __FILE__, __LINE__  
#      alias draw_without_fckeditor draw
#      def draw_with_fckeditor
#        draw_without_fckeditor do |map|
#          map.connect 'fckeditor/check_spelling', :controller => 'fckeditor', :action => 'check_spelling'
#          map.connect 'fckeditor/command', :controller => 'fckeditor', :action => 'command'
#          map.connect 'fckeditor/upload', :controller => 'fckeditor', :action => 'upload'
#          yield map
#        end
#      end
#      alias draw draw_with_fckeditor
#    end_eval
#  end
#end
# ************************************************************

