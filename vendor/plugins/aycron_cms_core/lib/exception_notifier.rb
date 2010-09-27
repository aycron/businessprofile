# ON RAILS 2.3 CONFIGURATION HAS TO BE LOADED ON ENVIRONMENTS/PRODUCTION.RB!!
#if Kernel.const_defined?("ExceptionNotifier")
#  RAILS_DEFAULT_LOGGER.info "Initializing Exception Notifier."
#  puts "Initializing Exception Notifier."
#  if defined?(EXCEPTION_NOTIFIER_TO) and defined?(EXCEPTION_NOTIFIER_PREFIX)
#    ExceptionNotifier.exception_recipients = EXCEPTION_NOTIFIER_TO
#    ExceptionNotifier.email_prefix = EXCEPTION_NOTIFIER_PREFIX
#    RAILS_DEFAULT_LOGGER.info "Exception Notifier activated, using configuration provided."
#    puts "Exception Notifier activated, using configuration provided."
#  else
#    RAILS_DEFAULT_LOGGER.info "Exception Notifier activated, custom configuration not found. Using default."
#    puts "Exception Notifier activated, custom configuration not found. Using default."
#    ExceptionNotifier.exception_recipients = "info@aycron.com"
#  end
#else
#  RAILS_DEFAULT_LOGGER.info "Exception Notifier not found."
#  puts "Exception Notifier not found."
#end

# By default, the ExceptionNotifier won't work on DEVELOPMENT mode.
# If you want to test it change the line 12 of config/environments/development.rb to 
# config.action_controller.consider_all_requests_local = false