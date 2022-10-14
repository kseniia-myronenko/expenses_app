class UsersController < AuthorizedController
  skip_before_action :check_authorization, :check_user

  def new
    if logged_in?
      redirect_to root_path
    else
      @user = User.new
    end
  end

  def show; end

  # rubocop:disable Metrics/AbcSize

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      flash[:success] = I18n.t('authentication.success.sign_up')
      redirect_to root_path
    else
      flash.now[:danger] = @user.errors.full_messages.to_sentence
      render :new
    end
  end

  # rubocop:enable Metrics/AbcSize

  private

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end
end
