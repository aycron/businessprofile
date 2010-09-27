ActionController::Routing::Routes.draw do |map|
  
  map.resources :profiles, :path_prefix => "/admin", :controller=> "profiles", :active_scaffold => true
  map.resources :user_profiles, :path_prefix => "/admin", :controller=> "user_profiles", :active_scaffold => true
  map.resources :pages, :path_prefix => "/admin", :controller=> "pages", :active_scaffold => true
  
  map.ga_config "/admin/ga_config", :controller=> "ga_config", :action => "index"  
  map.locate_on_map '/admin/profiles/:id/locate_on_map', :controller => "profiles", :action => "locate_on_map"
  map.user_locate_on_map '/admin/user_profiles/:id/locate_on_map', :controller => "user_profiles", :action => "locate_on_map"
  
  map.root :controller => "home"
  map.page "/page/:page_name", :controller => "site"  , :action=> "page"
  map.connect ':profile_id', :controller => "site", :action => "show_profile"
  map.connect ':profile_id/show_phone', :controller => "site", :action => "show_phone"
  map.connect ':profile_id/print_map', :controller => "site", :action => "print_map"
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  
end
