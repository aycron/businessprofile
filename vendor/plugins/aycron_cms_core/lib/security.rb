# NOW USING AYCRON ACTIVE SCAFFOLD CONTROLLER PERMISSIONS (SEE ACTIVE_SCAFFOLD_AYCRON.RB)

#class Security
#
#  def Security.can_edit(role_id, controller, session)
#    Security.get_permission(role_id, controller, session) > 1
#  end
#
#  def Security.can_view(role_id, controller, session)
#    Security.get_permission(role_id, controller, session) > 0
#  end
#
#  def Security.get_permission(role_id, controller, session)
#    permission = session["perm_" + controller]
#    if permission.nil?
#      permission = Security.load_permission(role_id, controller)
#      session["perm_" + controller] = permission
#      puts "setting session perm_" + controller
#    end
#    #puts "Controller:#{controller} - Permission:#{permission}"
#    permission
#  end
#  
#  def Security.load_permission(role_id, controller)
#    controller_stripped = controller[0...(controller.size - 10)]
#    rc = RoleController.find_by_role_id_and_controller(role_id, controller_stripped)
#    if rc.nil?
#      permission = 0
#    else
#      permission = (rc.can_edit ? 1 : 0) + (rc.can_view ? 1 : 0)
#    end
#    permission
#  end
#end

## This uses Roles, RoleControllers and Users for permissions.
#
#module AycronCmsSecurity
#
#  module InstanceMethods  
#
#    def authorized_for_create?
#      if current_user.role.is_super_admin
#        return true
#      else
#        # TODO: ACTIVESSCAFFOLD CONTROLLER NEEDS TO BE THE SAME AS THE MODEL
#        rc = RoleController.find(:first, :conditions => {:role_id => current_user.role.id, :controller => self.class.to_s.pluralize})
#        return (not rc.nil? and rc.can_edit)
#      end
#    end
#  
#    def authorized_for_update?
#      if current_user.role.is_super_admin
#        return true
#      else
#        # TODO: ACTIVESSCAFFOLD CONTROLLER NEEDS TO BE THE SAME AS THE MODEL
#        rc = RoleController.find(:first, :conditions => {:role_id => current_user.role.id, :controller => self.class.to_s.pluralize})
#        return (not rc.nil? and rc.can_edit)
#      end
#    end
#  
#    def authorized_for_destroy?
#      if current_user.role.is_super_admin
#        return true
#      else
#        # TODO: ACTIVESSCAFFOLD CONTROLLER NEEDS TO BE THE SAME AS THE MODEL
#        rc = RoleController.find(:first, :conditions => {:role_id => current_user.role.id, :controller => self.class.to_s.pluralize})
#        return (not rc.nil? and rc.can_edit)
#      end
#    end
#  
#    def authorized_for_read?
##      if not current_user.nil?
##        if current_user.role.is_super_admin
##          return true
##        else
##          # TODO: ACTIVESSCAFFOLD CONTROLLER NEEDS TO BE THE SAME AS THE MODEL
##          rc = RoleController.find(:first, :conditions => {:role_id => current_user.role.id, :controller => self.class.to_s.pluralize})
##          return (not rc.nil? and rc.can_view)
##        end
##      else
##        return false
##      end
## ON PRODUCTION MODE IT MAKES LIST'S NESTED LINKS TO NOT SHOW!
#      return true
#    end
#
#  end
#
#end
#    
#class ActiveRecord::Base
#  include AycronCmsSecurity::InstanceMethods
#end
#
