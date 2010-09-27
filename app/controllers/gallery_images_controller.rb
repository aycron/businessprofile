class GalleryImagesController < AycronCmsController
  layout "admin"
  
  active_scaffold :gallery_image do |config|
    
    config.create.multipart = true
    config.update.multipart = true
    
    config.create.columns = [:image]
    config.update.columns = [:image]
    config.show.columns = [:image, :position,:created_at, :updated_at]
    config.list.columns = [:image, :position]    
    
    config.list.sorting = {:position => :asc}
    
    config.columns[:image].description = "Imagen a mostrar."
    
    config.action_links.add 'up', :parameters => {:model => self.model}, :label => 'Up', :type => :record, :position => false, :method => 'put'
    config.action_links.add 'down', :parameters => {:model => self.model}, :label => 'Down', :type => :record, :position => false, :method => 'put'
    
     
 end
end