module OptionsHelper
  
  def value_form_column(record, input_name)
    case record.option_type
      when STRING_OPTION_TYPE
        text_field :record, :value, :name => input_name, :class => 'text-input'
      when TEXT_OPTION_TYPE
        text_area :record, :value, :name => input_name, :cols => 55
      when RICH_TEXT_OPTION_TYPE
        fckeditor_textarea( :record, "value", :ajax => true, :toolbarSet => "OptionValue",
            :width => FCKEDITOR_WIDTH, :height => FCKEDITOR_HEIGHT, :bodyClass => "rich_text_option" )
      when PASSWORD_OPTION_TYPE
        password_field :record, :value, :name => input_name, :class => 'text-input'
    end
  end
  
  def value_column(record)
    case record.option_type
      when STRING_OPTION_TYPE
        h record.value
      when TEXT_OPTION_TYPE
        h record.value
      when RICH_TEXT_OPTION_TYPE
        record.value
      when PASSWORD_OPTION_TYPE
        "*****************"
    end
  end
  
  def description_column(record)
    record.description
  end
  
end
