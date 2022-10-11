class SpendingsController < AuthorizedController
  skip_before_action :check_authorization, only: :index
  before_action :set_spending, except: %i[index new create]

  def index
    user = User.find(params[:user_id])
    @spendings = user.spendings
  end

  def new
    @spending = current_user.spendings.new
  end

  def show; end

  def create
    @spending = current_user.spendings.create(spending_params)

    if @spending.valid?
      flash[:info] = I18n.t('spending.success.created')
      redirect_to @spending
    else
      flash[:danger] = @spending.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit; end

  def update
    if @spending.update(spending_params)
      flash[:info] = I18n.t('spending.success.updated')
      redirect_to @spending
    else
      flash[:danger] = @spending.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @spending.destroy
    flash[:info] = I18n.t('spending.success.destroyed')
    redirect_to spendings_path
  end

  private

  def spending_params
    params.require(:spending).permit(:amount, :description, :category_id, :user_id)
  end

  def set_spending
    @spending = current_user.spendings.find(params[:id])
  end
end
