# HERE ARE THE ACTIVE SCAFFOLD OVERRIDES

# *******************************************************************
# ADDED: Date fields can have blank values
# *******************************************************************
module ActiveScaffold
  module Helpers
    # Helpers that assist with the rendering of a Form Column
    module FormColumnHelpers
      # This method decides which input to use for the given column.
      # It does not do any rendering. It only decides which method is responsible for rendering.
      def active_scaffold_input_for(column, scope = nil)
        options = active_scaffold_input_options(column, scope)
        options = javascript_for_update_column(column, scope, options)
        # first, check if the dev has created an override for this specific field
        if override_form_field?(column)
          send(override_form_field(column), @record, options[:name])
        # second, check if the dev has specified a valid form_ui for this column
      elsif column.form_ui and override_input?(column.form_ui)
          # ADD COLUMN OPTIONS 
          send(override_input(column.form_ui), column, options.merge(column.options))
        # fallback: we get to make the decision
        else
          if column.association
            # if we get here, it's because the column has a form_ui but not one ActiveScaffold knows about.
            raise "Unknown form_ui `#{column.form_ui}' for column `#{column.name}'"
          elsif column.virtual?
            active_scaffold_input_virtual(column, options)

          else # regular model attribute column
            # if we (or someone else) have created a custom render option for the column type, use that
            if override_input?(column.column.type)
              send(override_input(column.column.type), column, options)
            # final ultimate fallback: use rails' generic input method
            else
              # for textual fields we pass different options
              text_types = [:text, :string, :integer, :float, :decimal]
              options = active_scaffold_input_text_options(options) if text_types.include?(column.column.type)
              if column.column.type == :string && options[:maxlength].blank?
                options[:maxlength] = column.column.limit
                options[:size] ||= ActionView::Helpers::InstanceTag::DEFAULT_FIELD_OPTIONS["size"]
              end
              options[:include_blank] = true if column.column.type == :date # ADDED FOR DATE FIELDS
              input(:record, column.name, options.merge(column.options))
            end
          end
        end
      end
    end
  end
end


# *************************************************************
# ADDED: Do NOT truncate text values on show and list. 
#        Replace \n with <br>
# *************************************************************
module ActiveScaffold
  module Helpers
    module ListColumnHelpers
  
      def active_scaffold_column_text(column, record)
        clean_column_value(record.send(column.name)).gsub("\r\n", "<br/>").gsub(/\n/, "<br/>")
      end

    end
  end
end


# *************************************************************
# ADDED: Change DEFAULT LISTING from LISTS. 
#   ACTIVE SCAFFOLD /VENDOR/PLUGINS/ACTIVE_SCAFFOLD/LIB/ACTIVE_SCAFFOLD/CONFIG/CORE.RB MODIFIED!
# *************************************************************
#module ActiveScaffold::Config
#  class Core < Base
#    def label(options={})
#      as_(@label, options) || model.human_name(options.merge(options[:count].to_i == 1 ? {} : {:default => model.human_name.pluralize}))
#    end
#  end
#end


# *****************************************************************************
# ADDED: Change default behaviour of ActiveScaffold Actions.
#        All the authorized actions ask if the current user can do that action.
#        ALL ACTIVE SCAFFOLD AUTHORIZED ACTIONS WERE COMMENTED ON ACTIVESCAFFOLD PLUGIN!
# *****************************************************************************
module AycronActiveScaffoldAuthorizedActions
  def list_authorized?
    current_user_can_view?(self.class.to_s)
  end
  def show_authorized?
    current_user_can_view?(self.class.to_s)
  end
  def create_authorized?
    current_user_can_edit?(self.class.to_s)
  end
  def update_authorized?
    current_user_can_edit?(self.class.to_s)
  end
  def delete_authorized?
    current_user_can_edit?(self.class.to_s)
  end
  def search_authorized?
    current_user_can_view?(self.class.to_s)
  end

  private

  # Finds out if the current user can view associated views of a controller
  def current_user_can_view?(my_controller)
    my_controller.to_s.gsub!('Controller', '')
    my_controller = my_controller.demodulize
    if not current_user.nil?
      if current_user.role.is_super_admin || CONTROLLERS_ALLOWED.include?(my_controller)
        return true
      else
        # TODO: improvement needed. Store in a multidimensional array.
        rc = RoleController.find(:first, :conditions => {:role_id => current_user.role_id, :controller => my_controller})
        return (not rc.nil? and rc.can_view)
      end
    else
      return false
    end
  end

  # Finds out if the current user can view associated views of a controller
  def current_user_can_edit?(my_controller)
    if not current_user.nil?
      if current_user.role.is_super_admin
        return true
      else
        # TODO: improvement needed. Store in a multidimensional array.
        my_controller.gsub!("Admin::", "")
        my_controller = my_controller[0...(my_controller.size - 10)]
        rc = RoleController.find(:first, :conditions => {:role_id => current_user.role_id, :controller => my_controller})
        return (not rc.nil? and rc.can_edit)
      end
    else
      return false
    end
  end
end
