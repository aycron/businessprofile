local_user = ENV['USER'] || ENV['USERNAME']

#users is a map defined in the project/httpd_gw/trunk/capfile
svn_user = users[local_user] || local_user

set :user, svn_user

ssh_options[:forward_agent] = true
default_run_options[:pty] = true

stamp = Time.now.utc.strftime("%Y%m%d%H%M%S")

if ENV['DEPLOY'] == 'PRODUCTION'
  puts "*** Deploying to the PRODUCTION gateways!"
  role :gateway, *production_gateways
else
  puts "*** Deploying to the BETA gateways!"
  role :gateway, *beta_gateways
end

set :httpd_gw_conf_file, "#{application}.conf"
set :httpd_gw_source_dir, "/tmp/#{application}"
set :httpd_gw_source, "#{httpd_gw_source_dir}/#{httpd_gw_conf_file}"
set :httpd_gw_dest_dir, "/etc/httpd/conf.d"
set :httpd_gw_dest, "#{httpd_gw_dest_dir}/#{httpd_gw_conf_file}"

desc "Deploy any gtw mods onto the production servers."
task :deploy do
  checkout
  _deploy_httpd_gw
  cleanup
end  

task :remove  do
  on_rollback {}
  run "cd #{httpd_gw_dest_dir} && sudo unlink #{httpd_gw_conf_file}"
  run "sudo /etc/init.d/httpd configtest && sudo /etc/init.d/httpd reload"
end

task :_deploy_httpd_gw  do
  on_rollback {}
  run "sudo cp #{httpd_gw_source} #{httpd_gw_dest}.#{stamp}"
  run "cd #{httpd_gw_dest_dir} && sudo ln -fs #{httpd_gw_conf_file}.#{stamp} #{httpd_gw_conf_file}"
  run "sudo /etc/init.d/httpd configtest && sudo /etc/init.d/httpd reload"
end

task :checkout  do
  on_rollback {}
  run "/bin/rm -rf /tmp/#{application}"
  run "cd /tmp && svn checkout #{repository_path} #{application}"
end
    
task :cleanup  do
  on_rollback {}
  run "/bin/rm -rf /tmp/#{application}"
end
