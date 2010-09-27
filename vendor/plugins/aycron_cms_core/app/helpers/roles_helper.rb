module RolesHelper
  def controllers_column(record)
    permissions = ""
    if record.is_super_admin
      permissions = "This role is the super admin. It has all the permissions."
    else
      controllers = get_controllers_list
      controllers.each do |controller|
        rc = record.role_controllers.find_by_controller(controller)
        if not rc.nil?
          if rc.can_edit
            permission = "edit"
          elsif rc.can_view
            permission = "view"
          else
            permission = "none"
          end
        else
          permission = "none"
        end
        permissions += controller + ": " + permission + "<br>"
      end
    end
    permissions
  end
  
end
