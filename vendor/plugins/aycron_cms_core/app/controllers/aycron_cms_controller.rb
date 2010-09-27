class AycronCmsController < ApplicationController
  include SimpleCaptcha::ControllerHelpers if SIMPLE_CAPTCHA_ACTIVE
  unloadable
  before_filter :authenticate
  layout 'admin'
  
  def up
    # get the model passed by params
    klass = Kernel.const_get(params[:model])
    @item = klass.find(params[:id])
    @item.move_higher
    do_list
    render :partial => 'admin/refresh'
  end

  def down
    # get the model passed by params
    klass = Kernel.const_get(params[:model])
    @item = klass.find(params[:id])
    @item.move_lower
    do_list
    render :partial => 'admin/refresh'
  end
  
end
