class PagesController < AycronCmsController
   layout "admin"
   
  active_scaffold :page do |config|
    
    #Columns configuration
    config.create.columns = [:name, :title, :content, :position, :photo]
    config.update.columns = [:name, :title, :content, :position, :photo]
    config.show.columns = [:name, :title, :content, :position, :photo]
    config.list.columns = [:name, :title, :position, :photo]
    
    #FCKEditor
    config.columns[:content].form_ui = :fckeditor
    
    #Actions Excluded
    #config.actions.exclude :create, :Search, :delete
    config.actions.exclude :delete
    
    #Label
    config.label = 'Pages'
    
    config.columns[:title].description = "Titulo de la Pagina."
    config.columns[:name].description = "Nombre de la Pagina."
    config.columns[:content].description = "Contenido de la Pagina"
    config.columns[:position].description = "Orden de las Paginas"
  
  end
  
end
