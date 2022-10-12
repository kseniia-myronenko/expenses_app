class SpendingFilterService < ApplicationService
  def initialize(params, user)
    @params = params
    @spendings = user.spendings.all
  end

  def call
    filter_by_amount
    filter_by_category
    ordering
  end

  private

  def filter_by_amount
    if @params[:min] && @params[:max]
      @spendings = @spendings.where('amount >= ?', @params[:min])
                             .and(@spendings.where('amount <= ?', @params[:max]))
    elsif @params[:min] || @params[:max]
      @spendings = @spendings.where('amount >= ?', @params[:min])
                             .or(@spendings.where('amount <= ?', @params[:max]))
    end

    @spendings
  end

  def filter_by_category
    if @params[:category]
      category = Category.find_by(heading: @params[:category])
      @spendings = @spendings.where(category_id: category.id)
    else
      @spendings
    end

    @spendings
  end

  def ordering
    @spendings = @params[:order] ? @spendings.order(amount: @params[:order]) : @spendings
  end
end
