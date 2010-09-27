class UsersController < AycronCmsController
  unloadable

  active_scaffold :user do |config|
    #config.create.multipart = true
    #config.update.multipart = true
    config.columns.add :hashed_password_confirmation
    config.columns[:hashed_password].label = "Password"
    config.columns[:hashed_password_confirmation].label = "Password Confirmation"
    config.columns[:role].form_ui = :select
    config.list.columns = [:username, :complete_name, :role]
    config.create.columns = [:username, :email, :role, :first_name, :last_name, :hashed_password, :hashed_password_confirmation]
    config.update.columns = [:username, :email, :role, :first_name, :last_name, :hashed_password, :hashed_password_confirmation]
    config.show.columns = [:username, :email, :role, :first_name, :last_name, :created_at, :updated_at]
    config.list.per_page = 10
    config.list.sorting = {:username => 'ASC'}
  end
    
  # the same on the model!
  def do_destroy
    if User.find(params[:id]).role.is_super_admin
      flash[:error] = "The super admin user can't be deleted."
    end
    super
  end

  # home page
  def home
    @user = User.find(session['user_id'])
  end

end
