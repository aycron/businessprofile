ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  map.homeAdmin 'admin/', :controller => "users", :action => "home"
  map.login  '/authentications/login', :controller => 'authentications', :action => 'login'
  map.logout '/authentications/logout', :controller => 'authentications', :action => 'logout'
  map.verify '/authentications/verify', :controller => 'authentications', :action => 'verify'
  map.resources :options, :path_prefix => "/admin", :active_scaffold => true
  map.resources :options_super, :path_prefix => "/admin", :active_scaffold => true
  map.resources :users, :path_prefix => "/admin", :active_scaffold => true
  map.resources :roles, :path_prefix => "/admin", :active_scaffold => true
  #map.after_login '/after_login', :controller => "users", :action => "index"  redefinir!

  if FCKEDITOR_S3_ACTIVE
    RAILS_DEFAULT_LOGGER.info "FckEditorS3 enabled."
    puts "FckEditorS3 enabled."
    map.connect '/fckeditor/check_spelling', :controller => 'FckeditorS3', :action => 'check_spelling'
    map.connect '/fckeditor/command', :controller => 'FckeditorS3', :action => 'command'
    map.connect '/fckeditor/upload', :controller => 'FckeditorS3', :action => 'upload'
  else
    RAILS_DEFAULT_LOGGER.info "FckEditorS3 disabled."
    puts "FckEditorS3 disabled."
    map.connect '/fckeditor/check_spelling', :controller => 'fckeditor', :action => 'check_spelling'
    map.connect '/fckeditor/command', :controller => 'fckeditor', :action => 'command'
    map.connect '/fckeditor/upload', :controller => 'fckeditor', :action => 'upload'
  end


  if SIMPLE_CAPTCHA_ACTIVE
    #simple captcha route
    map.simple_captcha '/simple_captcha/:action', :controller => 'simple_captcha'
  end

  if BLOG_ACTIVE
    map.namespace :blog do |blog_map|
      blog_map.resources :blog_categories, :path_prefix => "/admin", :active_scaffold => true
      blog_map.resources :blog_posts, :path_prefix => "/admin", :active_scaffold => true
      blog_map.resources :blog_post_comments, :path_prefix => "/admin", :active_scaffold => true       
      blog_map.resources :blog_post_comments_to_validate, :path_prefix => "/admin", :active_scaffold => true 
      blog_map.blog '/', :controller => "blog", :action => "blog"
      blog_map.blog_year '/year/:year', :controller => "blog", :action => "blog_by_year"  
      blog_map.blog_category '/category/:category', :controller => "blog", :action => "blog_by_category"   
      blog_map.blog_search '/search', :controller => "blog", :action => "blog_search"     
      blog_map.blog_permalink '/link/:permalink', :controller => "blog", :action => "blog_permalink"       
      blog_map.blog_comments '/posts', :controller => "blog_post_comments", :action => "blog_comment_add"   
    end
    map.blog_feed '/blog/feed', :controller => "feeds", :action => "blog_rss_feed"         
    map.comments_to_validate '/admin/blog_post_comments_to_validate', :controller => "Blog::BlogPostCommentsToValidate", :action => "index"      
  end


  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
