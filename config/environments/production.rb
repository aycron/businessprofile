# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true

# See everything in the log (default is :info)
# config.log_level = :debug

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# config.action_mailer.raise_delivery_errors = false

# Enable threaded mode
# config.threadsafe!

# fix to make Exception Notifier work on Rails 2.3 !!!
  config.after_initialize do
    ExceptionNotifier.exception_recipients = EXCEPTION_NOTIFIER_TO
    ExceptionNotifier.email_prefix = EXCEPTION_NOTIFIER_PREFIX
    ExceptionNotifier.sender_address = EXCEPTION_NOTIFIER_FROM
  end
  
  # This will rotate log files. It'll generate up to 50 log files of 1 megabyte each.
  # WON'T WORK ON WINDOWS AND ON RAKE TASKS
  if ENV['RAKE'].to_s != 'true' and not (RUBY_PLATFORM =~ /(:?mswin|mingw)/)
    config.logger = Logger.new(config.log_path, 10, 10.megabyte)
    config.logger.level = Logger::INFO
  end