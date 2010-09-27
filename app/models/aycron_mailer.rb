class AycronMailer < ActionMailer::Base
  
  def contact(name, email, message, profile, contact_email)
    @subject      = profile.contact_me_subject
    @body         = {:name => name, :email => email, :message => message }
    @recipients   = contact_email
    @from         = email
    @sent_on      = Time.now
    @content_type = "text/html"
  end

end
