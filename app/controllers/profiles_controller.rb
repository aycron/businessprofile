class ProfilesController < AycronCmsController
   layout :set_layout
     
  active_scaffold :profile do |config|
    
    #Columns configuration
    config.create.columns = [:title, :short_description, :active, :logo, :image, :description, :address, :phones, :site_link_name, :website, :facebook_url, :contact_email, :second_contact_email, :contact_me_subject, :mail_subject, :mail_body, :gallery_title, :gallery_label, :meta_description, :meta_keywords, :meta_verify_v1, :google_analytics]
    config.update.columns = [:title, :short_description, :active,  :logo, :image, :description, :address, :phones, :site_link_name, :website, :facebook_url, :contact_email, :second_contact_email, :contact_me_subject, :mail_subject, :mail_body, :gallery_title, :gallery_label, :meta_description, :meta_keywords, :meta_verify_v1, :google_analytics]
    config.show.columns = [:title, :short_description, :active,  :logo, :image, :description, :address, :phones, :url, :site_link_name, :website, :facebook_url, :contact_email, :second_contact_email, :contact_me_subject, :mail_subject, :mail_body, :gallery_title, :gallery_label, :gallery_images, :meta_description, :meta_keywords, :meta_verify_v1, :google_analytics]
    config.list.columns = [:title, :url, :short_description, :gallery_images, :profile_tabs]
    
    #FCKEditor
    config.columns[:description].form_ui = :fckeditor
    config.columns[:address].form_ui = :fckeditor
    config.columns[:phones].form_ui = :fckeditor
    #config.columns[:mail_body].form_ui = :fckeditor
    
    #Actions Excluded
    #config.actions.exclude :create, :Search, :Delete
    
    config.columns[:gallery_images].set_link('nested', :parameters => {:associations => :gallery_images})

    #Label
    config.label = 'Business Profiles'
    config.columns[:google_analytics].label = "Google Analytics"
    config.columns[:gallery_label].label = "Link de Galeria"
    config.columns[:contact_email].label = "Email de Contacto 1:"
    config.columns[:second_contact_email].label = "Email de Contacto 2:"
    config.columns[:contact_me_subject].label = "Asunto del correo Contactarme:"
    config.columns[:mail_subject].label = "Asunto del correo Enviar por Correo:"
    config.columns[:mail_body].label = "Cuerpo del correo:"
    
    config.columns[:google_analytics].description = "ID de propiedad web de GA (Ajustes de Google Analytics > Configuración del perfil > Código de seguimiento)"
    config.columns[:site_link_name].description = "Nombre de la etiqueta que precede al link de la página."
    config.columns[:active].description = "Activar para desplegar en el directorio general."
    config.columns[:gallery_label].description = "Etiqueta para link de galerias de imagenes."
    config.columns[:title].description = "Titulo del perfil."
    config.columns[:short_description].description = "Descripcion corta del site para desplegar en el directorio general."
    config.columns[:description].description = "Descripcion del perfil."
    config.columns[:address].description = "Direcciones."
    config.columns[:phones].description = "Telefonos."
    config.columns[:website].description = "URL del sitio web."
    config.columns[:facebook_url].description = "URL de su pagina de facebook."
    config.columns[:contact_email].description = "Email de quien recibira el correo de la opcion Contactarme."
    config.columns[:second_contact_email].description = "Segundo email de quien recibira el correo de la opcion Contactarme."
    config.columns[:image].description = "Imagen principal"  
    config.columns[:logo].description = "Logo del Perfil"
    config.columns[:mail_subject].description = "Asunto del correo de la opcion Enviar por Correo"  
    config.columns[:mail_body].description = "Cuerpo del correo de la opcion Enviar por Correo"
    config.columns[:gallery_title].description = "Titulo de la Galeria."
    config.columns[:meta_description].description = "Meta descripción de la página. Usado para busquedas en internet."
    config.columns[:meta_keywords].description = "Palabras clave de la página. Usado para busquedas en internet."
    config.columns[:meta_verify_v1].description = "Verificación V1 de la página. Usado para busquedas en internet."
    config.columns[:contact_me_subject].description = "Asunto del correo de la opcion Contactarme."
        
    config.action_links.add 'locate_on_map', :parameters => {:model => Profile}, :label => 'Localización', :type => :record, :page=>true, :position => false
  end
  
  def conditions_for_collection
    ['profiles.id = ?', current_user.profile_id] unless current_user.role.is_super_admin
  end
  
  def locate_on_map
    @profile = Profile.find(params[:id])
    @marker = @profile.marker
    
  end
   
  def save_location
    profile = Profile.find(params[:id])
       
    unless profile.marker
      Marker.create(:profile_id => profile.id, :lat => params[:latitude].to_f, :lng => params[:longitude].to_f)
    else  
      profile.marker.update_attributes(:lat => params[:latitude].to_f, :lng => params[:longitude].to_f)
    end
    
    redirect_to :action => 'locate_on_map'
  end
   
  private
  
  def set_layout
    case action_name
      when 'locate_on_map' then nil
    else 'admin'
    
    end
  end
  
end
