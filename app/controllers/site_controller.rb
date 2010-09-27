class SiteController < ApplicationController
  layout :set_layout

  def set_layout
    case action_name
      when 'show_profile' then 'profile'
      when 'page' then 'footer_page'
    else nil
    
    end
  end
  
  def print_map
    @profile = Profile.find(params[:id])
    if @profile
      @marker = @profile.marker
      @google_analytics = @profile.google_analytics
    end
    @key = Option.find_by_key(GOOGLE_MAPS_API_KEY).value
  end
  
  def show_profile
    @profile = Profile.find_by_url(params[:profile_id])
    redirect_to 'public/404.html' if @profile.nil?
    @configurations = {}
    GAConfig.all.collect{|ga| @configurations[ga.event] = ga.value}
    if @profile
      @google_analytics = @profile.google_analytics 
      @marker = @profile.marker
      
      reg = Regexp.new('^http(s?):\/\/')
      if reg.match(@profile.website)
        @website = @profile.website
      else
        @website = 'http://' + @profile.website if @profile.website
      end 
    end
    @pages = Page.find(:all ,:order => "position")
    @footer_text = Option.getValue(FOOTER_TEXT)
    @googleMapsKey = Option.getValue(GOOGLE_MAPS_API_KEY)
    
    if params[:gallery_open]
      @gallery_images = GalleryImage.find_all_by_profile_id(@profile.id).paginate(:page => params[:page] || 1, :per_page => 9)
    end
  end
  
  def show_phone
    @profile = Profile.find(params[:id])
    
    render :update do |page|
      page.replace_html 'section-1-phones', @profile.phones 
    end
  end
  
  def send_email
    @profile = Profile.find(params[:id])
    
    reg = EMAIL_SHORT
    if reg.match(params[:contact][:email])
      unless @profile.contact_email.blank?
        AycronMailer.deliver_contact(params[:contact][:name]+' '+params[:contact][:surname], params[:contact][:email], params[:contact][:message],@profile, @profile.contact_email)
      end
      
      unless @profile.second_contact_email.blank?
        AycronMailer.deliver_contact(params[:contact][:name]+' '+params[:contact][:surname], params[:contact][:email], params[:contact][:message],@profile, @profile.second_contact_email)
      end
      flash[:contact_notice] = 'El mensaje ha sido entregado satisfactoriamente.'
    else
      flash[:contact_error] = 'Error: Formato del email incorrecto.'
    end
    
    redirect_to :action => :show_profile, :profile_id => @profile.url, :ga => 'contactanos'
  end
  
  def page
    @pages = Page.find(:all ,:order => "position")
    @page = Page.find_by_name(params[:page_name])
  end
  
  def show_next_image
    @position = params[:position].to_i + 1  || 1
    @profile = Profile.find(params[:profile_id])
    @configurations = {}
    GAConfig.all.collect{|ga| @configurations[ga.event] = ga.value}
    
    render :update do |page|
      page.replace_html 'section-6-main', :partial => 'image_slider'
    end
  end
  
  def show_prev_image
    @position = params[:position].to_i - 1
    @profile = Profile.find(params[:profile_id])
    @configurations = {}
    GAConfig.all.collect{|ga| @configurations[ga.event] = ga.value}
    
    render :update do |page|
      page.replace_html 'section-6-main', :partial => 'image_slider'
    end
  end
  
end
