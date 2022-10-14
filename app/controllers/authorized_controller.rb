class AuthorizedController < BaseController
  before_action :check_authorization, :check_user

  private

  def check_authorization
    redirect_to signup_path unless current_user
  end

  def check_user
    render_not_found if User.find(params[:user_id]) != current_user
  end
end
