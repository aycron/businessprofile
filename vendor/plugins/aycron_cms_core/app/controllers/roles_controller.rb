class RolesController < AycronCmsController
  unloadable

  active_scaffold :role do |config|
    #config.create.multipart = true
    #config.update.multipart = true
    config.columns.add :controllers
    config.columns[:controllers].label = "Permissions"
    config.list.columns = [:name]
    config.create.columns = [:name, :controllers]
    config.update.columns = [:name, :controllers]
    config.show.columns = [:name, :controllers]
  end

  def after_create_save(record)
    save_permissions(record)
  end

  def after_update_save(record)
    save_permissions(record)
  end

  # the same on the model!
  def do_destroy
    role = Role.find(params[:id])
    if role.is_super_admin
      flash[:error] = "The super admin role can't be deleted."
    end
    super
  end

  private
  
  def save_permissions(record)
    permissions = params[:record][:permissions]
    permissions.each do |permission|
      perm_controller = permission[0]
      perm_value = permission[1]
      rc = RoleController.find(:first, :conditions => {:role_id => record.id, :controller => perm_controller})
      if rc.nil?
        rc = RoleController.new(:role_id => record.id, :controller => perm_controller)
      end
      rc.can_view = perm_value == "1" || perm_value == "2"
      rc.can_edit = perm_value == "2"
      rc.save!
    end
  end
    
end
