class SpendingsController < AuthorizedController
  skip_before_action :check_user, only: :index
  before_action :set_spending, except: %i[index new create]
  before_action :set_categories, only: %i[new edit update create]

  def index
    @user = User.find(params[:user_id])
    @categories = @user.categories.pluck(:heading)
    @spendings = Spendings::FilterService.call(params, @user)
    @spendings = Spendings::SortService.call(@spendings, params)
    @total = @spendings.sum(&:amount)
  end

  def show; end

  def new
    @spending = current_user.spendings.build
  end

  # rubocop:disable Metrics/AbcSize

  def create
    @spending = current_user.spendings.create(spending_params)

    if @spending.valid?
      flash[:info] = I18n.t('spending.success.created')
      redirect_to user_spending_path(current_user, @spending)
    else
      flash.now[:danger] = @spending.errors.full_messages.to_sentence
      render :new
    end
  end

  # rubocop:enable Metrics/AbcSize

  def edit; end

  def update
    if @spending.update(spending_params)
      flash[:info] = I18n.t('spending.success.updated')
      redirect_to user_spending_path(current_user, @spending)
    else
      flash.now[:danger] = @spending.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @spending.destroy
    flash[:info] = I18n.t('spending.success.destroyed')
    redirect_to user_spendings_path
  end

  private

  def spending_params
    params.require(:spending).permit(:amount, :description, :category_id, :user_id)
  end

  def set_spending
    @spending = current_user.spendings.find(params[:id])
  end

  def set_categories
    @categories = current_user.categories.pluck(:heading, :id)
  end
end
