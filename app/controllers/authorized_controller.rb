class AuthorizedController < BaseController
  before_action :check_authorization

  private

  def check_authorization
    redirect_to signup_path unless current_user
  end
end
