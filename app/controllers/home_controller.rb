class HomeController < ApplicationController
  
  def index
    @profiles = Profile.find(:all)  
    @appTitle = Option.getValue(APPLICATION_TITLE)
    @publicHost = Option.getValue(PUBLIC_HOST)
  end

end
