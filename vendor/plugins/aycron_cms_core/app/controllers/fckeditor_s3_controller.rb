require 'fileutils'
require 'tmpdir'
require 'aws/s3'
include AWS::S3

class FckeditorS3Controller < ActionController::Base
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

  if ATTACHMENT_FU_S3_JO and RAILS_ENV == 'production'
    # if on production, use JO custom configs.
    @@s3_config_path = '/var/jo.s3.yml'
    @@s3_config = YAML.load(ERB.new(File.read(@@s3_config_path)).result).symbolize_keys
    # bucket_name is on amazon_s3.yml!
    @@s3_config_path_for_bucket = RAILS_ROOT + '/config/amazon_s3.yml'
    @@s3_config_for_bucket = YAML.load(ERB.new(File.read(@@s3_config_path_for_bucket)).result)[RAILS_ENV].symbolize_keys
    @@bucket_name = @@s3_config_for_bucket[:bucket_name]
  else
    @@s3_config_path = RAILS_ROOT + '/config/amazon_s3.yml'
    @@s3_config = YAML.load(ERB.new(File.read(@@s3_config_path)).result)[RAILS_ENV].symbolize_keys
    @@bucket_name = @@s3_config[:bucket_name]
  end


  def initialize
    if not AWS::S3::Base.connected?
      logger.debug "connecting to S3 ..."
      AWS::S3::Base.establish_connection!(@@s3_config.slice(:access_key_id, :secret_access_key, :server, :port, :use_ssl, :persistent, :proxy))
      bucketAlreadyExists = false
      AWS::S3::Service.buckets.each { |bucketAux|
        if bucketAux.name == @@bucket_name
          bucketAlreadyExists = true
        end
      }
      if bucketAlreadyExists == false
        logger.info "creating bucket #{@@bucket_name} ..."
        AWS::S3::Bucket.create(@@bucket_name)
      end
      # we don't use "file" "image" "media" "flash" folders
    end
    super
  end

  
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
      currentFolder = params[:CurrentFolder]
      if currentFolder == '/'
        currentFolder = ""
      else
        currentFolder = currentFolder[1..9999] if currentFolder[0,1] == '/'  # remove first "/"
      end
      @fck_url = AWS::S3::S3Object.url_for("", @@bucket_name, :authenticated => false) + currentFolder
      
      AWS::S3::Bucket.objects(@@bucket_name, :prefix => currentFolder).each { |s3object|
        position = s3object.key.index('/', currentFolder.length)
        if position
          # found a / after the prefix => in on a subfolder
          folder = s3object.key[currentFolder.length..position]
          folder.chop! if folder[-1,1] == '/'
          @folders.push folder unless @folders.include? folder
        else
          if s3object.key.include? "_$folder$"
            folder = s3object.key[currentFolder.length..s3object.key.index("_$folder$")-1]
            @folders.push folder unless @folders.include? folder
          else
            file = s3object.key[currentFolder.length..9999]
            @files[file] = "" unless file == "" or not include_files  # todo: find out size (kb)
          end
        end
      }
    rescue => e
      @errorNumber = 110 if @errorNumber.nil?
      logger.error e
      logger.error "Exception raised Getting folders and files. Url: #{@fck_url} | Current_folder: #{@current_folder}"
    end
  end

  def create_folder
    begin 
      key = params[:CurrentFolder] + params[:NewFolderName] + "_$folder$"
      key = key[1..9999] if key[0,1] == '/'  # remove first "/"
      if params[:NewFolderName] =~ @@BadUrlRegularExpression
        @errorNumber = 102
      elsif AWS::S3::S3Object.exists?(key, @@bucket_name)
        @errorNumber = 101
      else
        S3Object.store(key, "", @@bucket_name, :access => :public_read)
        @errorNumber = 0
      end
    rescue => e
      @errorNumber = 110 if @errorNumber.nil?
      logger.error e
      logger.error "Exception raised Creating folder. Key: #{key}"
    end
  end
  
  def upload_file
    begin
      @new_file = params[:NewFile]
      ftype = @new_file.content_type.strip unless @new_file.content_type.nil?
      if not MIME_TYPES.include?(ftype)
        @errorNumber = 202
        logger.info "upload_file: #{ftype} is invalid MIME type"
      else
        key = (params[:CurrentFolder] || "") + @new_file.original_filename.gsub(@@BadUrlRegularExpression, '-')  # sanitize
        key = key[1..9999] if key[0,1] == '/'  # remove first "/"
        S3Object.store(key, @new_file, @@bucket_name, :access => :public_read)
        @errorNumber = 0
      end
    rescue => e
      @errorNumber = 110 if @errorNumber.nil?
      logger.error e
      logger.error "Exception raised Uploading file. Key: #{key}"
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
