require 'digest/sha1'

class User < ActiveRecord::Base
  belongs_to :role
  validates_presence_of :email, :username, :hashed_password, :role
  validates_uniqueness_of :username, :email
  validates_confirmation_of :hashed_password
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
                      :message => 'must be valid'

  def before_destroy
    if self.role.is_super_admin
      errors.add_to_base "The super admin user can't be deleted."   # DOES NOT SHOW ERROR MESSAGE! HAVE TO ADD IT @ CONTROLLER
      false
    end
  end

  def before_update
    oldUser = User.find(self.id)
    if oldUser.hashed_password != self.hashed_password
      self.hashed_password = Digest::SHA1.hexdigest(self.hashed_password)[0..39]
    end
  end

  def before_create
    self.hashed_password = Digest::SHA1.hexdigest(self.hashed_password)[0..39]
  end
   
  def to_label
    username
  end

  def complete_name
    "#{self.first_name} #{self.last_name}"
  end

end
