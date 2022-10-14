class BaseController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  helper_method :current_user

  def current_user
    User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def render_not_found
    render file: Rails.public_path.join('404.html'), status: :not_found
  end

  def logged_in?
    !current_user.nil?
  end
end
