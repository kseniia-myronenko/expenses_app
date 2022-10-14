class CategoriesController < AuthorizedController
  before_action :set_category, except: %i[index new create]

  def index
    @categories = current_user.categories
  end

  def show; end

  def new
    @category = current_user.categories.new
  end

  def create
    @category = current_user.categories.create(category_params)

    if @category.valid?
      flash[:info] = I18n.t('category.success.created')
      redirect_to @category
    else
      flash.now[:danger] = @category.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    if @category.update(category_params)
      flash[:info] = I18n.t('category.success.updated')
      redirect_to @category
    else
      flash.now[:danger] = @category.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @category.destroy
    flash[:info] = I18n.t('category.success.destroyed')
    redirect_to categories_path
  end

  private

  def category_params
    params.require(:category).permit(:heading, :body, :display, :user_id)
  end

  def set_category
    @category = current_user.categories.find(params[:id])
  end
end
