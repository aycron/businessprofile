module ProfileHelper
  def gallery_images_column(record)
    if record.gallery_images.nil? or record.gallery_images.size == 0
      message = "click para agregar"
    else
      message = ""
      record.gallery_images.each do |gallery_image|
        message += image_tag(gallery_image.image.url(:mini), :border => 0) + '&nbsp;'
      end
      message += "<br>click para agregar o editar"
    end
    message
  end
  
  def active_form_column(record, input_name)
    check_box :record, :active, :name => input_name
  end

end
