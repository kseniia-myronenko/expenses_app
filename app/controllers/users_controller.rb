class UsersController < AuthorizedController
  skip_before_action :check_authorization, only: %i[new create]
  before_action :set_user, except: %i[new create]
  before_action :redirect_to_user, except: %i[new create]

  def show; end

  def new
    if logged_in?
      redirect_to root_path
    else
      @user = User.new
    end
  end

  # rubocop:disable Metrics/AbcSize

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      flash[:success] = I18n.t('authentication.success.sign_up')
      redirect_to root_path
    else
      flash[:danger] = @user.errors.full_messages.to_sentence
      render :new
    end
  end

  # rubocop:enable Metrics/AbcSize

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to @user
      flash[:success] = I18n.t('user.success.updated')
    else
      flash[:danger] = @user.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:info] = I18n.t('user.success.destroyed')
    redirect_to signup_path
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end

  def redirect_to_user
    redirect_to @user if User.find(params[:id]) != @user
  end
end