# This is the base code for deploying applications to any server.
# project level variables should be defined in deploy.rb

# To deploy the facade code in the right server, please change the :apps and :repository variable, 
# you can see the line commented out in the right place.

# Add your local / remote username pair to this hash please...
users = {
  'leonardo' => 'leonardo.sanvitale',
  'carlos.dantiags' => 'carlos.dantiags',
  'gustavo.cardenas' => 'gustavo.cardenas'
}

# flag defaults
self[:uses_whenever]||=false
self[:uses_ferret]||=false
self[:uses_s3]||=false
self[:uses_logrotate]||=false
self[:production_servers]||=beta_servers
self[:production_database]||=production_servers
self[:create_database]||=true
self[:create_database_user]||=true
self[:production_database]||='localhost'
self[:beta_database]||='localhost'
self[:database_name]||=database_username

local_user = ENV['USER'] || ENV['USERNAME']
svn_user = users[local_user] || local_user
set :user, users[local_user]
#set :user, 'mongrel'

set :repository,  "svn+ssh://#{svn_user}@#{repository_path}"

ssh_options[:forward_agent] = true
set :deploy_to, "/sites/#{application}"
set :runner, 'mongrel'

if ENV['DEPLOY'] == 'PRODUCTION'
  puts "*** Deploying to the PRODUCTION server! ***"
  set :domain, production_servers
  set :database_domain, production_database
  set :database_host, production_database
  if self[:production_gateway]
    set :gateway, production_gateway
  end
else
  puts "*** Deploying to the BETA server! ***"
  set :domain, beta_servers
  set :database_domain, beta_database
  set :database_host, beta_database  
  if self[:beta_gateway]
    set :gateway, beta_gateway
  end
end

database_domain ||= domain 
database_domain << {:primary => true}

default_run_options[:pty] = true

role :app, *domain
role :web, *domain
role :db, *database_domain

task :after_update_code do
  run "rm -f #{current_release}/config/database.yml"
  run "ln -s #{deploy_to}/#{shared_dir}/config/database.yml #{current_release}/config/database.yml"
  
  if uses_ferret
    run "rm #{current_release}/config/ferret_server.yml"
    run "ln -s #{deploy_to}/#{shared_dir}/config/ferret_server.yml #{current_release}/config/ferret_server.yml"
  end

  if uses_s3
    run "rm #{current_release}/config/amazon_s3.yml"
    run "ln -s #{deploy_to}/#{shared_dir}/config/amazon_s3.yml #{current_release}/config/amazon_s3.yml"    
  end

  run "rm -rf #{current_release}/log"
  run "cd #{current_release} && ln -s #{deploy_to}/#{shared_dir}/log log"
  
  #log rotate

  if uses_logrotate
    sudo "cp #{current_release}/config/logrotate-#{application} /etc/logrotate.d/logrotate-#{application}"  
  end

  run "rm -rf #{current_release}/tmp"
  run "cd #{current_release} && ln -s #{deploy_to}/#{shared_dir}/tmp tmp"

  run "rm -rf #{current_release}/public/uploads"
  run "cd #{current_release}/public && ln -s #{deploy_to}/#{shared_dir}/public/uploads uploads"

  run "rm -rf #{current_release}/public/assets"
  run "cd #{current_release}/public && ln -s #{deploy_to}/#{shared_dir}/public/assets assets"

  run "rm -rf #{current_release}/public/old"
  run "cd #{current_release}/public && ln -s #{deploy_to}/#{shared_dir}/public/old old"

  run "sudo mkdir -p -m 777 #{deploy_to}/#{shared_dir}/index" 
  run "sudo mkdir -p -m 777 #{deploy_to}/#{shared_dir}/index/production"
  run "rm -rf #{current_release}/index"
  run "cd #{current_release} && ln -s #{deploy_to}/#{shared_dir}/index index"
  
  public_dir = "#{current_release}/public" # this row was added to fix permissions
  shared_dir = "#{deploy_to}/shared"
  sudo "chown -R mongrel:mongrel #{public_dir}" # this row was added to fix permissions
  sudo "chown -R mongrel:mongrel #{shared_dir}"
  sudo "chown mongrel:mongrel #{current_release}"
  sudo "chmod 775 #{current_release}/script/console"

  if uses_ferret
    sudo "chmod 775 #{current_release}/script/ferret_server"
    sudo "chmod -R 777 #{current_release}/index/production"  
    sudo "chown -R mongrel:mongrel #{current_release}/index"    
  end
    
  #lines added to fix permissions for ferret server
  sudo "chmod -R 777 #{shared_dir}/log"  
  
  if run_rake 
    run "cd #{current_release}; export RAILS_ENV=production; export RAKE=true; rake --trace db:migrate"    
  end
  
  if uses_whenever
    run "cd #{current_release} && whenever --update-crontab #{application}"
    sudo "chmod 775 #{current_release}/script/runner"
  end
  
end

namespace :deploy do
  task :stop, :roles => :app do
    sudo "mongrel_rails cluster::stop -C #{deploy_to}/#{shared_dir}/config/#{application}.yml"
    if uses_ferret
      run "cd #{current_release};[ -f log/ferret.pid ] && /usr/lib/ruby/gems/1.8/gems/acts_as_ferret-0.4.3/script/ferret_server --root=#{current_release} -e production stop || echo \"ferret already stopped\" "
    end
  end

  task :start, :roles => :app do
    if uses_ferret
      run "cd #{current_release}; /usr/lib/ruby/gems/1.8/gems/acts_as_ferret-0.4.3/script/ferret_server --root=#{current_release} -e production start"
      sleep 120      
    end

    sudo "mongrel_rails cluster::start -C #{deploy_to}/#{shared_dir}/config/#{application}.yml"
  end

  desc "restart the web server"
  task :restart, :roles => :app do
    begin
      sudo "mongrel_rails cluster::stop -C #{deploy_to}/#{shared_dir}/config/#{application}.yml"
      
      if uses_ferret
        run "cd #{current_release};[ -f log/ferret.pid ] && /usr/lib/ruby/gems/1.8/gems/acts_as_ferret-0.4.3/script/ferret_server  --root=#{current_release} -e production stop || echo \"ferret already stopped\" "
        run "cd #{current_release};/usr/lib/ruby/gems/1.8/gems/acts_as_ferret-0.4.3/script/ferret_server --root=#{current_release} -e production start"
        sleep 120        
      end

      sudo "mongrel_rails cluster::start -C #{deploy_to}/#{shared_dir}/config/#{application}.yml"


    rescue RuntimeError => e
      puts e
      puts "Probably not a big deal, so I'll keep trying"
    end
  end
end

task :initial_setup do
  run "  sudo mkdir -p -m 777 /sites/#{application}"
  run "  sudo mkdir -p -m 777 /sites/#{application}/backups"  
  run "  sudo mkdir -p -m 777 /sites/#{application}/releases"
  run "  sudo mkdir -p -m 777 /sites/#{application}/shared"
  run "  sudo mkdir -p -m 777 /sites/#{application}/shared/config"
  run "  sudo mkdir -p -m 777 /sites/#{application}/shared/log"
  run "  sudo mkdir -p -m 777 /sites/#{application}/shared/tmp"
  run "  sudo mkdir -p -m 777 /sites/#{application}/shared/system"  
  run "  sudo mkdir -p -m 777 /sites/#{application}/shared/public"
  run "  sudo mkdir -p -m 777 /sites/#{application}/shared/public/uploads"
  run "  sudo mkdir -p -m 777 /sites/#{application}/shared/public/assets"  
  run "  sudo mkdir -p -m 777 /sites/#{application}/shared/tmp/cache"
  run "  sudo mkdir -p -m 777 /sites/#{application}/shared/tmp/pids"
  run "  sudo mkdir -p -m 777 /sites/#{application}/shared/tmp/sessions"
  
  if uses_s3
    run "  cd /sites/#{application}/shared/config; svn export #{repository}/config/amazon_s3.yml amazon_s3.yml"
    run "  sudo chmod 777 /sites/#{application}/shared/config/amazon_s3.yml"
  end
    
  run "  cd /sites/#{application}/shared/config; svn export #{repository}/config/database.yml.tmpl database.yml"
  run "  sudo chmod 777 /sites/#{application}/shared/config/database.yml"

  if create_database
    run "  mysql --host=#{database_host} --user=root --password=`cat /var/jo.mysql.yml | awk '{print $2}'` -e \"CREATE DATABASE IF NOT EXISTS #{database_name}_production\""  
  end
  
  run " "
  
  if create_database_user
    run "  mysql --host=#{database_host} --user=root --password=#{database_root_password} -e \"GRANT ALL PRIVILEGES ON *.* TO '#{database_username}'@'localhost' IDENTIFIED BY '#{database_password}' WITH GRANT OPTION;\""
    run "  mysql --host=#{database_host} --user=root --password=#{database_root_password} -e \"GRANT ALL PRIVILEGES ON *.* TO '#{database_username}'@'%' IDENTIFIED BY '#{database_password}' WITH GRANT OPTION;\""    
  end
  
  # adding the database configuration
  run "  cd /sites/#{application}/shared/config; svn export #{repository}/config/database.yml.tmpl database.yml"
  run "  sudo chmod 777 /sites/#{application}/shared/config/database.yml"    
  
  if uses_ferret
    # adding ferret server configuration
    run "  cd /sites/#{application}/shared/config; svn export #{repository}/config/ferret_server.yml"  
  end
  
  gems_install

end

task :gems_install do
#  run "  sudo gem install soap4r"
#  run "  sudo gem install eventmachine"
#  run "  sudo gem install ferret"
#  run "  sudo gem install acts_as_ferret"  
#  run "  sudo gem install fastercsv" 
end
