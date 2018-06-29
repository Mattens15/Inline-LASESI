class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  #rescue_from ActiveRecord::RecordNotFound, with: :render_404
  
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
end
