class AddCommonUserToRole < ActiveRecord::Migration
  def self.up
    role = Role.create(:name => 'common user', :is_super_admin => false)
        
    controllers = get_controllers_list
    controllers.each do |controller|
      rc = RoleController.new(:role => role, :controller => controller)
      
      if controller == 'ProfileTabs' || controller == 'GalleryImages' ||  controller == 'UserProfiles'
        rc.can_view = true
        rc.can_edit = true
      else     
        if controller == 'Profiles'
          rc.can_view = true
          rc.can_edit = false
        else
          rc.can_view = false
          rc.can_edit = false
        end
      end
      
      rc.save!
    end
    
  end
  
  def self.down
    role = Role.find_by_name(common user)
    
    if rc
      role.role_controllers.each do |rc|
        rc.destroy
      end
    
      role.destroy
    end
  end
end
