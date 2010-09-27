#if any gateway, here is where it should be set
set :production_gateway, 'sandbox.aycron.com'
set :beta_gateway, 'sandbox.aycron.com'

#application name. beware, hungry-girl.com.yml should exist 
set :application, "businessprofile.com"

#repository path, to be used in, for example, svn+ssh://#{repository_path}
set :repository_path,  "svn.aycron.com/home/svn/businessprofile/site/trunk"

#application database username
set :database_username, "businessprofile"

#application database password
set :database_password, "businessprofile"

#production server name
set :production_servers, ['sandbox.aycron.com']
set :production_database, ["sandbox.aycron.com"]
#beta server name
set :beta_servers, ['sandbox.aycron.com']
set :beta_database, ['localhost']


#password for the target database root user
set :database_root_password, "`cat /var/jo.mysql.yml | awk '{print $2}'`"

#default is false
set :uses_ferret, false

set :run_rake, true

#default is false
set :uses_whenever, false

#default is false
set :uses_s3, false

#default is false
set :uses_logrotate, false

#default is set to true

load 'config/deploys/base_deploy'
