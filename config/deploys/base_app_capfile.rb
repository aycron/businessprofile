local_user = ENV['USER'] || ENV['USERNAME']

#users is a map defined in the project/httpd_app/trunk/capfile
svn_user = users[local_user] || local_user

set :repository, "svn+ssh://#{svn_user}@#{repository_path}"

set :user, users[local_user]
#set :user, "mongrel"

ssh_options[:forward_agent] = true
default_run_options[:pty] = true
  
set :httpd_app_source_dir, "/tmp/#{application}/trunk"

if ENV['DEPLOY'] == 'PRODUCTION'
  puts "*** Deploying to the PRODUCTION server!"
  if self[:production_gateway]
    set :gateway, production_gateway  
  end
  role :apps, *production_servers
  set :httpd_app_conf_file, production_http_conf_file
else
  puts "*** Deploying to the BETA  server!"
  if self[:beta_gateway]
    set :gateway, beta_gateway  
  end
  role :apps, *beta_servers
  set :httpd_app_conf_file, beta_http_conf_file
end


set :env, "beta"

stamp = Time.now.utc.strftime("%Y%m%d%H%M%S")

set :httpd_app_source, "#{httpd_app_source_dir}/#{httpd_app_conf_file}"
set :httpd_app_dest_dir, "/etc/httpd/conf.d"
set :httpd_app_dest_conf_file, "#{httpd_app_dest_dir}/#{httpd_app_conf_file}.#{stamp}"

set :mongrel_source, "/tmp/#{application}/trunk/#{mongrel_conf_file}"
set :mongrel_dest_dir, "/sites/#{application}/shared/config"
set :mongrel_dest, "#{mongrel_dest_dir}/#{mongrel_conf_file}"

desc "Deploy any http mods onto the production servers."
task :deploy do
  checkout
  _deploy_httpd_app
  cleanup
end  

task :_deploy_httpd_app  do
  on_rollback {}
  run "sudo cp #{httpd_app_source} #{httpd_app_dest_conf_file}"
  run "cd #{httpd_app_dest_dir} && sudo ln -fs #{httpd_app_dest_conf_file} #{httpd_app_conf_file}"
  
  # Mongrel
  run "sudo cp #{mongrel_source} #{mongrel_dest}.#{stamp}"
  run "sudo mkdir -p /etc/mongrel_cluster"
  run "sudo rm -f /etc/mongrel_cluster/#{mongrel_conf_file}"
  run "sudo ln -s #{mongrel_dest} /etc/mongrel_cluster/#{mongrel_conf_file}"
  run "cd #{mongrel_dest_dir} && sudo ln -fs #{mongrel_dest}.#{stamp} #{mongrel_dest}"  
  
  run "sudo /etc/init.d/httpd configtest && sudo /etc/init.d/httpd reload"
end

desc "Remove this httpd configuration and reload server."
task :remove_httpd_app  do
  on_rollback {}
  run "cd #{mongrel_dest_dir} && unlink #{mongrel_dest}"  
  run "cd #{httpd_app_dest_dir} && sudo unlink #{httpd_app_conf_file}"  
  
  run "sudo /etc/init.d/httpd configtest && sudo /etc/init.d/httpd reload"
end

task :checkout  do
  on_rollback {}
  run "cd /tmp && mkdir -p #{application} && cd #{application} && svn checkout #{repository}"
end
    
task :cleanup  do
  on_rollback {}
  run "/bin/rm -rf /tmp/#{application}"
end
