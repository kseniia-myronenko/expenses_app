class SessionsController < BaseController
  def new
    redirect_to root_path if logged_in?
  end

  def create
    if set_user&.authenticate(params[:password])
      define_session(set_user)
      redirect_to root_path
      flash[:success] = I18n.t('authentication.success.logged_in')
    else
      flash[:danger] = I18n.t('authentication.errors.wrong_data')
      render :new
    end
  end

  def destroy
    reset_session
    flash[:success] = I18n.t('authentication.success.logged_out')
    redirect_to signup_path
  end

  private

  def set_user
    User.find_by(username: params[:username])
  end

  def define_session(set_user)
    session[:user_id] = set_user.id
  end
end
