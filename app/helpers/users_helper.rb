module UsersHelper
  
  def profile_assigned_column(record)
    unless record.role.is_super_admin
      @profiles = Profile.all
      select_tag('profile_'+record.id.to_s, '<option value=0>- Selecciona uno -</option>'+options_from_collection_for_select(@profiles, 'id', 'title', record.profile ? record.profile_id : 0), :class => 'profiles', :name => record.id)
    end if record.role
  end
  
  def hashed_password_confirmation_form_column(record, input_name)
    if record.hashed_password_confirmation.nil?
      record.hashed_password_confirmation = record.hashed_password
    end
    password_field "record", "hashed_password_confirmation", :class => "text-input"
  end

  # remove super admin role from Roles list. Only one super admin user!
  def options_for_association_conditions(association)
    if association.name == :role
      ['roles.id != ?', Role.find_by_is_super_admin(true)]
    else
      super
    end
  end

end
