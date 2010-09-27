## Filters added to this controller apply to all controllers in the application.
## Likewise, all the methods added will be available for all controllers.

# THIS CLASS NEEDS TO BE INHERITED BY THE APPLICATION_CONTROLLER.RB

class AasApplicationController < ActionController::Base
  unloadable
  helper :application
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  include ExceptionNotifiable # send mail when an exception occurs
  local_addresses.clear # even if it's local

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  # If an ActiveScaffold::ActionNotAllowed exception is raised show a "Action not allowed" message.
  def rescue_action_in_public(exception)
    if exception.is_a? ActiveScaffold::ActionNotAllowed 
      render(:file => "#{RAILS_ROOT}/public/action_not_allowed.html.erb", :status => "403 Action Not Allowed")
    else
      super
    end
  end 

  def log_current_session_data
    current_session_data = request.session.to_hash
    logger.warn "************************* SESSION *********************"
    logger.warn current_session_data.inspect.gsub("}}, ", "}}, \n")
  end
end
