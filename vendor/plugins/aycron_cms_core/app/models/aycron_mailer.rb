class AycronMailer < ActionMailer::Base

  # sends a 'Password reset request' notification.
  # user MUST NOT be nil.
  # random_code MUST NOT be nil.
  # host MUST NOT be nil.
  def password_reset_notification(user, random_code, host)
    @subject      = 'Password reset request'
    @body         = {:user => user, :random_code => random_code, :host => host }
    @recipients   = user.email
    @from         = Option.getValue(OPTION_MAIL_FROM)
    @sent_on      = Time.now
    @content_type = "text/html"
  end

end
