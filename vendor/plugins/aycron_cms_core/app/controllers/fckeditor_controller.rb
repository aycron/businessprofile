require 'fileutils'
require 'tmpdir'

class FckeditorController < ActionController::Base
  skip_before_filter :verify_authenticity_token

  @@BadUrlRegularExpression = /[^a-z0-9._\-]+/i
  
  RXML = <<-EOL
  xml.instruct!
    #=> <?xml version="1.0" encoding="utf-8" ?>
  xml.Connector("command" => params[:Command], "resourceType" => 'File') do
    xml.CurrentFolder("url" => @fck_url, "path" => params[:CurrentFolder])
    xml.Folders do
      @folders.each do |folder|
        xml.Folder("name" => folder)
      end
    end if !@folders.nil?
    xml.Files do
      @files.keys.sort.each do |f|
        xml.File("name" => f, "size" => @files[f])
      end
    end if !@files.nil?
    xml.Error("number" => @errorNumber) if !@errorNumber.nil?
  end
  EOL
  
  # figure out who needs to handle this request
  def command   
    logger.debug "Command: #{params[:Command]}"
    if params[:Command] == 'GetFoldersAndFiles' || params[:Command] == 'GetFolders'
      get_folders_and_files
    elsif params[:Command] == 'CreateFolder'
      create_folder
    elsif params[:Command] == 'FileUpload'
      upload_file
    end
    
    render :inline => RXML, :type => :rxml unless params[:Command] == 'FileUpload'
  end 
  
  def get_folders_and_files(include_files = true)
    @folders = Array.new
    @files = {}
    begin
      @fck_url = upload_directory_path
      @current_folder = current_directory_path
      Dir.entries(@current_folder).each do |entry|
        next if entry =~ /^\./
        path = @current_folder + entry
        @folders.push entry if FileTest.directory?(path)
        @files[entry] = (File.size(path) / 1024) if (include_files and FileTest.file?(path))
      end
    rescue => e
      @errorNumber = 110 if @errorNumber.nil?
      logger.error e
      logger.error "Exception raised Getting folders and files. Url: #{@fck_url} | Current_folder: #{@current_folder}"
    end
  end

  def create_folder
    begin 
      @fck_url = current_directory_path
      path = @fck_url + params[:NewFolderName]
      logger.debug "path: " + path.to_s
      if !(File.stat(@fck_url).writable?)
        @errorNumber = 103
      elsif params[:NewFolderName] =~ @@BadUrlRegularExpression
        @errorNumber = 102
      elsif FileTest.exists?(path)
        @errorNumber = 101
      else
        Dir.mkdir(path,0775)
        @errorNumber = 0
      end
    rescue => e
      @errorNumber = 110 if @errorNumber.nil?
      logger.error e
      logger.error "Exception raised Creating folder. Path: #{path}"
    end
  end
  
  def upload_file
    begin
      @new_file = check_file(params[:NewFile])
      @fck_url = upload_directory_path
      ftype = @new_file.content_type.strip unless @new_file.content_type.nil?
      if not MIME_TYPES.include?(ftype)
        @errorNumber = 202
        logger.info "upload_file: #{ftype} is invalid MIME type"
      else
        path = current_directory_path + "/" + @new_file.original_filename.gsub(@@BadUrlRegularExpression, '-')  # sanitize
        File.open(path,"wb",0664) do |fp|
          FileUtils.copy_stream(@new_file, fp)
        end
        @errorNumber = 0
      end
    rescue => e
      @errorNumber = 110 if @errorNumber.nil?
      logger.error e
      logger.error "Exception raised Uploading file. Path: #{path}"
    end

    render :text => %Q'
    <script>
      if (window.parent.frames[\'frmUpload\']) {
        window.parent.frames[\'frmUpload\'].OnUploadCompleted(#{@errorNumber});
      }
      if (window.parent.parent.frames[\'frmMain\']) {
        window.parent.parent.frames[\'frmMain\'].OnUploadCompleted(#{@errorNumber},"#{@fck_url}/#{CGI::escape(@new_file.original_filename)}");
      }
    </script>'
  end

  def upload
    self.upload_file
  end
  
  include ActionView::Helpers::SanitizeHelper
  def check_spelling
    require 'cgi'
    require 'fckeditor_spell_check'

    @original_text = params[:textinputs] ? params[:textinputs].first : ''
    plain_text = strip_tags(CGI.unescape(@original_text))
    @words = FckeditorSpellCheck.check_spelling(plain_text)

    render :file => "#{Fckeditor::PLUGIN_VIEWS_PATH}/fckeditor/spell_check.rhtml"
  end
  
  private
  def current_directory_path
    base_dir = "#{UPLOADED_ROOT}/#{params[:Type] ? params[:Type] : "File"}"
    Dir.mkdir(base_dir,0775) unless File.exists?(base_dir)
    check_path("#{base_dir}#{params[:CurrentFolder]}")
  end
  
  def upload_directory_path
    uploaded = ActionController::Base.relative_url_root.to_s+"#{UPLOADED}/#{params[:Type] ? params[:Type] : "File"}"
    "#{uploaded}#{params[:CurrentFolder]}"
  end
  
  def check_file(file)
    # check that the file is a tempfile object
    # RAILS_DEFAULT_LOGGER.info "CLASS OF UPLOAD OBJECT: #{file.class}"
    unless "#{file.class}" == "Tempfile" || "StringIO"
      @errorNumber = 403
      throw Exception.new
    end
    file
  end
  
  def check_path(path)
    exp_path = File.expand_path path
    if exp_path !~ %r[^#{File.expand_path(RAILS_ROOT)}/public#{UPLOADED}]
      @errorNumber = 403
      throw Exception.new
    end
    path
  end
end
