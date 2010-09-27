class ProfileTab < ActiveRecord::Base
  belongs_to :profile
  acts_as_list :scope => :profile, :order => "position ASC"
  
  validate_on_create :check_max_tabs
    
  def to_label
    name
  end  
  
  private
  
  def check_max_tabs
    if self.profile.profile_tabs.size >= 3
      errors.add_to_base 'Solo pueden ser creadas un máximo de tres pestañas.' 
    end
  end
end
