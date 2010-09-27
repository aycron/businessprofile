class Blog::BlogCategoriesController < AycronCmsController
  unloadable
   
  active_scaffold :blog_category do |config|
    config.label = "Blog Category" 
    config.list.label = "Blog Categories" 
    config.list.columns = [ :name, :position ]
    config.create.columns = [ :name ]
    config.update.columns =  [ :name ]
    config.show.columns =  [ :name, :position ]
    config.list.sorting = {:position => :asc}
    config.action_links.add 'up', :parameters => {:model => self.model}, :label => 'Up', :type => :record, :position => false, :method => 'put'
    config.action_links.add 'down', :parameters => {:model => self.model}, :label => 'Down', :type => :record, :position => false, :method => 'put'
    
  end

end
