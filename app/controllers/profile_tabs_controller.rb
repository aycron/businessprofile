class ProfileTabsController < AycronCmsController
  layout "admin"
  
  active_scaffold :profile_tabs do |config|
    config.create.multipart = true
    config.update.multipart = true
    
    config.create.columns = [:name, :tab_type, :video_url, :content]
    config.update.columns = [:name, :tab_type, :video_url, :content]
    config.show.columns = [:name, :tab_type, :position, :video_url, :content]
    config.list.columns = [:name, :tab_type, :position]    
     
    config.list.sorting = { :position => :asc }
    
    config.columns[:name].description = "Nombre de la pestaña a mostrar."
    config.columns[:video_url].description = "URL del video a mostrar."
    config.columns[:content].description = "Contenido de la pestaña."
    
    config.columns[:tab_type].label = "Tipo"
    
    config.columns[:content].form_ui = :fckeditor
    
    config.action_links.add 'up', :parameters => {:model => self.model}, :label => 'Up', :type => :record, :position => false, :method => 'put'
    config.action_links.add 'down', :parameters => {:model => self.model}, :label => 'Down', :type => :record, :position => false, :method => 'put'  
  end
end