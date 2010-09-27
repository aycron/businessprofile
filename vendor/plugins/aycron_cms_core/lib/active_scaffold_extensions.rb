# *************************************************************
# ADDED: aycron specific form_ui
# *************************************************************
module AycronActiveScaffoldActionView

  def active_scaffold_input_fckeditor(column, options)
    if column.singular_association?
      active_scaffold_input_singular_association(column, options)
    elsif column.plural_association?
      active_scaffold_input_plural_association(column, options)
    else
      fckeditor_textarea( :record, column.name, :ajax => true, :toolbarSet => FCKEDITOR_TOOLBAR_SET,
            :width => FCKEDITOR_WIDTH, :height => FCKEDITOR_HEIGHT, :bodyClass => options[:bodyClass] || "fckeditor_textarea" )
    end
  end

  def active_scaffold_input_aas_has_many_sorted(column, options)
    render :partial => "attachments/form_has_many_field", :locals => { :record => @record, :column => column, :sorted => true, :max_number => options[:max_number] || 100 }
  end

  def active_scaffold_input_aas_has_many_no_sorted(column, options)
    render :partial => "attachments/form_has_many_field", :locals => { :record => @record, :column => column, :sorted => false, :max_number => options[:max_number] || 100 }
  end

  def active_scaffold_input_aas_has_one(column, options)
    render :partial => "attachments/form_has_one_field", :locals => { :record => @record, :column => column }
  end

end
  
module AycronActiveScaffoldActionController

  protected
  def process_uploads(record)
    process_file_sorting(record)
    active_scaffold_config.columns.each { |column|
      if column.form_ui == :aas_has_many_sorted ||
            column.form_ui == :aas_has_many_no_sorted ||
            column.form_ui == :aas_has_one
        process_file_uploads(record, column.association.name)
      end
    }
  end

  private

  # update order of older files
  def process_file_sorting(owner)
    params.each do |key, value|
      if key[0..14] == "pos_attachment_"
        att_id = key[15,10]
        attachment = Attachment.find(att_id)
        if value.to_i < 0
          attachment.destroy
        else
          attachment.position = value
          attachment.save!
        end
      end
    end
  end
  
  # upload new files
  def process_file_uploads(owner, association)
    if params[association]
      params[association].each do |key, value|
      logger.debug "param: #{key} - #{value} - #{value.class}"
      # only process files that got a size (and thus are not nil or empty etc)
      next unless value.is_a?(Tempfile) and value.size > 0
        image_number_parts = key.split("_")
        image_number = image_number_parts[image_number_parts.length - 1]
        position = params[association]["pos_file_#{image_number}"]
        attachment = association.to_s.classify.constantize.new({:uploaded_data => params[association][key]})
        attachment.attachable = owner
        attachment.position = position
        if attachment.save
          if owner.send(association).is_a? Array
            owner.send(association) << attachment
          else
            owner.send(association, attachment)
          end
          owner.save
        else  
          attachment.errors.each_full {|error| owner.errors.add_to_base(association.to_s.titleize + ": " + error) }
          raise ActiveRecord::RecordInvalid.new(owner)
        end
      end
    end
  end

end  
