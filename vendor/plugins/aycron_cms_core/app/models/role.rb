class Role < ActiveRecord::Base
  has_many :users, :order => :username, :dependent => :nullify
  has_many :role_controllers, :order => :controller, :dependent => :destroy
  validates_presence_of :name
  
  def before_destroy
    if self.is_super_admin
      errors.add_to_base "The super admin role can't be deleted."   # DOES NOT SHOW ERROR MESSAGE! HAVE TO ADD IT @ CONTROLLER
      false
    end
  end

end

