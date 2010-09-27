class AuthenticationsController < ApplicationController
  unloadable 
  layout "admin", :except => [:login, :reset_password, :update_password]
  
  def login
  end
  
  def verify
    hash_pass = Digest::SHA1.hexdigest(params[:user][:hashed_password])[0..39]
    user = User.find(:first, :conditions => 
          [AUTHETICATIONS_IDENTIFICATION_FIELD + " = ? and hashed_password = ?", params[:user][AUTHETICATIONS_IDENTIFICATION_FIELD], hash_pass])
    
    if user
      session['user_id'] = user.id
      if session['initial_uri'].nil?
        redirect_to after_login_path
      else
        redirect_to session['initial_uri']
      end
    else    
      flash[:warning] = "Bad " + AUTHETICATIONS_IDENTIFICATION_FIELD + "/password!" 
      redirect_to login_path
    end     
  end
  
  def logout
    reset_session
    redirect_to homeAdmin_path
  end
  
  def setAdminHashedPassword
    user = User.find(:first,:conditions => 
           ["username = ? and hashed_password = ?", 'admin', 'admin'])
    if user
      hash_pass = Digest::SHA1.hexdigest('admin')[0..39]
      if User.update(user.id, :hashed_password => hash_pass)
        flash[:notice] = "Admin password hashed."
      else
        flash[:warning] = "Admin password NOT hashed."
      end
      redirect_to login_path 
    else
      flash[:warning] = "Admin user not found. Has to exist a user with username Admin and password Admin (not hashed!) on the db."
      redirect_to login_path
    end
  end
  
  def forgot_password
    an_email = params[:user][:email]
    user = User.find(:first, :conditions => ["email = ?", an_email])
    
    if user
      random_code = random_alphanumeric
      user.password_reset_code = random_code
      if user.save
        AycronMailer.deliver_password_reset_notification(user, random_code, request.host)
        logger.info("Password reset notification sent to user #{user.username} at #{user.email}")
        flash[:warning] = "Password reset email sent to your email address. Check your inbox!"
        redirect_to login_path
      else
        logger.error("Error saving user password reset request")
        flash[:warning] = "Couldn\'t reset password for user #{user.username}"
      end
    else
      flash[:warning] = "User not found" 
      redirect_to login_path
    end
    
  end
  
  def random_alphanumeric(size=16)
    s = ""
    size.times { s << (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr }
    s
  end
  
  def reset_password
    @validation_code = params[:code]
  end
  
  def update_password
    validation_code = params[:validation_code]
    pass = params[:reset][:password]
    repass = params[:reset][:repassword]
    email = params[:reset][:email]
    
    a_user = User.find(:first, :conditions => ["password_reset_code = ?", validation_code])
    
    if valid? a_user, email, validation_code, pass, repass
      a_user.hashed_password = pass
      a_user.password_reset_code = nil
      a_user.save!
      flash[:notice] = "Your password has been successfully updated."
      redirect_to :action => 'login'
    else
      redirect_to :action => 'reset_password', :code => validation_code
    end
  end
  
  def valid?(a_user, email, validation_code, password, repassword)
    if(!a_user) 
      flash[:warning] = "No user found for the validation code. Please request a new password reset email."
      return false
    end
    
    if !(a_user.email.eql? email)
      flash[:warning] = "No user found for the validation code. Please request a new password reset email."
      return false
    end
    
    if !(password.eql? repassword)
      flash[:warning] = "Both passwords must be equal to each other"
      return false
    end
    
    if (password.empty?)
      flash[:warning] = "Please enter a password"
      return false      
    end
    true
  end
  
end
