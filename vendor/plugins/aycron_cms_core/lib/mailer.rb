# SAME ON ApplicationController.restartOptionsServerConfiguration !!!
begin
  # mail_delivery_method can be :smtp, :smtp_tls, :sendmail, :test
  delivery_method = Option.getValue(MAIL_DELIVERY_METHOD).nil? ? nil : Option.getValue(MAIL_DELIVERY_METHOD).strip
  if delivery_method == ':sendmail'
    ActionMailer::Base.delivery_method = :sendmail
  elsif delivery_method == ':test'
    ActionMailer::Base.delivery_method = :test
  else
    ActionMailer::Base.delivery_method = :smtp
  end
  ActionMailer::Base.smtp_settings = {
    :address  => Option.getValue(SMTP_ADDRESS).nil? ? nil : Option.getValue(SMTP_ADDRESS).strip,
    :port  => Option.getValue(SMTP_PORT).nil? ? nil : Option.getValue(SMTP_PORT).strip,
    :domain => Option.getValue(SMTP_DOMAIN).nil? ? nil : Option.getValue(SMTP_DOMAIN).strip,
    :user_name  => Option.getValue(SMTP_USER_NAME).nil? ? nil : Option.getValue(SMTP_USER_NAME).strip,
    :password  => Option.getValue(SMTP_PASSWORD).nil? ? nil : Option.getValue(SMTP_PASSWORD).strip
  }
  if delivery_method == ':smtp_tls' and RUBY_VERSION > "1.8.6"
    ActionMailer::Base.smtp_settings[:enable_starttls_auto] = true
  end
  smtp_authentication = Option.getValue(SMTP_AUTHENTICATION).nil? ? nil : Option.getValue(SMTP_AUTHENTICATION).strip
  if smtp_authentication == ':login' then 
    ActionMailer::Base.smtp_settings[:authentication] = :login
  elsif smtp_authentication == ':cram_md5'
    ActionMailer::Base.smtp_settings[:authentication] = :cram_md5
  else
    ActionMailer::Base.smtp_settings[:authentication] = :plain
  end
rescue => e
  RAILS_DEFAULT_LOGGER.error e
  RAILS_DEFAULT_LOGGER.error "... database not created yet?"
end
