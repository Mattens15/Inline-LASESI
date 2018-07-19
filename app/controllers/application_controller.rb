class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_no_cache
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  
  include SessionsHelper
  helper_method :current_user
  
  def current_user
    
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def render_404
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/404.html", layout: 'layouts/application', status: 404 }
      format.all { render nothing: true, status: 404 }
    end
  end
  
  def change_availability 
    if current_user && current_user.admin
      if $should_be_offline
        $should_be_offline=false
        puts "Website is now suspended...".red
      else
        $should_be_offline=true
        puts "Website has been restored!".green
      end
    end
    
      
    redirect_to "/"
    
    
  end
  def set_no_cache
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end
end
