namespace :aycron_cms_core do
  def setup_tasks
    require "config/environment"
    require 'fileutils'
    
    directory = File.join(RAILS_ROOT, '/vendor/plugins/aycron_cms_core/')
    require "#{directory}lib/fckeditor"
    require "#{directory}lib/fckeditor_version"
    require "#{directory}lib/fckeditor_file_utils"
    
    # create /public/stylesheets/aycron_cms_core
    if not File.exist?(File.join(RAILS_ROOT, '/public/stylesheets/aycron_cms_core/'))    
      FileUtils.mkdir(File.join(RAILS_ROOT, '/public/stylesheets/aycron_cms_core/'))
    end    
    # create /public/javascripts/aycron_cms_core
    if not File.exist?(File.join(RAILS_ROOT, '/public/javascripts/aycron_cms_core'))    
      FileUtils.mkdir(File.join(RAILS_ROOT, '/public/javascripts/aycron_cms_core'))
    end    
    
  end
  
  desc 'Install the FCKEditor components'
  task :install_fckeditor do
    setup_tasks
    puts "** Installing FCKEditor Plugin version #{FckeditorVersion.current}..."           

    FckeditorFileUtils.destroy_and_install 
         
    puts "** Successfully installed FCKEditor Plugin version #{FckeditorVersion.current}"
  end

  desc 'Install the multiple_file_upload component'
  task :install_multiple_file_upload do
    setup_tasks
    config_file = File.join(RAILS_ROOT, '/vendor/plugins/aycron_cms_core/public/javascripts/aycron_cms_core/multiple_file_upload.js')
    dest = File.join(RAILS_ROOT, '/public/javascripts/aycron_cms_core/multiple_file_upload.js')
    FileUtils.cp(config_file, dest) unless File.exist?(dest)
    config_file = File.join(RAILS_ROOT, '/vendor/plugins/aycron_cms_core/public/stylesheets/aycron_cms_core/multiple_file_upload.css')
    dest = File.join(RAILS_ROOT, '/public/stylesheets/aycron_cms_core/multiple_file_upload.css')
    FileUtils.cp(config_file, dest) unless File.exist?(dest)
  end

end