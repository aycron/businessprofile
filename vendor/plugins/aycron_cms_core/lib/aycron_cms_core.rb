# AycronCmsCore
DIRECTORIES_SEPARATOR = "::"
CONTROLLERS_NOT_ADMINABLE = [
          "AasApplication",
          "Application",
          "Authentications",
          "OptionsSuper",
          "AycronCms",
          "Fckeditor",
          "FckeditorS3",
          "Feeds"]
MODELS_NOT_ADMINABLE = [
          "BlogPostComment",
          "AycronMailer",
          "Mailer",
          "CacherObserver"]

def get_controllers_list
  controllers = []
  entries = Dir["#{RAILS_ROOT}/app/controllers/*.rb"]
  entries.concat(Dir["#{RAILS_ROOT}/app/controllers/**/*.rb"])
  entries.concat(Dir["#{RAILS_ROOT}/vendor/plugins/**/app/controllers/*.rb"])
  if BLOG_ACTIVE
    entries.concat(Dir["#{RAILS_ROOT}/app/controllers/blog/*.rb"])
  end
  entries.each do |entry|
    if entry =~ /_controller/
      controller = entry.gsub("_controller.rb", "").camelize
      last = controller.rindex(DIRECTORIES_SEPARATOR)
      controller = controller[(last + DIRECTORIES_SEPARATOR.length)..999] unless last.nil?
      controllers << controller
    end
  end
  controllers.uniq!
  controllers.sort!
  controllers -= CONTROLLERS_NOT_ADMINABLE
  return controllers
end

def get_models_list
  models = []
  entries = Dir["#{RAILS_ROOT}/app/models/*.rb"]
  entries.concat(Dir["#{RAILS_ROOT}/vendor/plugins/**/app/models/*.rb"])
  entries.each do |entry|
    if entry =~ /.rb/
      model = entry.gsub(".rb", "").camelize
      last = model.rindex(DIRECTORIES_SEPARATOR)
      model = model[(last + DIRECTORIES_SEPARATOR.length)..999] unless last.nil?
      models << model
    end
  end
  models.uniq!
  models.sort!
  models -= MODELS_NOT_ADMINABLE
  return models
end

ActiveScaffold.set_defaults do |config|
  config.security.current_user_method = :current_user
  config.security.default_permission = true
end
  
def current_user
  User.find(session['user_id']) unless session['user_id'].nil?
end
  
def current_user_id
  session['user_id']
end

def authenticate
  if session['user_id'].nil?
    session['initial_uri'] = request.request_uri
    redirect_to :controller => "authentications", :action => "login" 
  end
end

# Restarts the options configurations
def restartOptionsServerConfiguration
  # SAME ON config/initializers/mailer.rb !!!
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
end


def encrypt(data)
  c = OpenSSL::Cipher::Cipher.new(algorithm)
  c.encrypt
  c.key = key
  c.iv = iv
  e = c.update(data)
  e << c.final
  base64encoded = Base64.encode64(e)
  base64encoded.gsub!("\n", "") # remove \n
  return base64encoded
end

def decrypt(encryptedDataBase64)
  encryptedData = Base64.decode64(encryptedDataBase64)
  c = OpenSSL::Cipher::Cipher.new(algorithm)
  c.decrypt
  c.key = key
  c.iv = iv
  d = c.update(encryptedData)
  d << c.final
  return d
end

def key
  return Digest::SHA256.digest("13579juicyorange")
end

def iv
  return "juicyorange23456"
end

def algorithm
  return "aes-256-cbc"
end

