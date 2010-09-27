class GaConfigController < ApplicationController
  layout "admin"
  
  def index
    @configurations = GAConfig.all
    
  end
  
  def update
    params[:values].each do |event, value|
      GAConfig.find(event).update_attribute(:value, value.to_i)
    end
    
    flash[:notice] = "Configuraciones actualizadas satisfactoriamente."
    
    redirect_to :action => :index
  end
  
end
