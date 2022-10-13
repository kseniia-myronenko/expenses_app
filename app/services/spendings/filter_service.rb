module Spendings
  class FilterService < ApplicationService
    def initialize(params, user)
      @params = params
      @spendings = user.spendings.all
    end

    def call
      filter_by_amount
      filter_by_category
    end

    private

    # rubocop:disable Metrics/AbcSize

    def filter_by_amount
      if @params[:min].present? && @params[:max].present?
        @spendings = @spendings.where('amount >= ?', @params[:min])
                               .and(@spendings.where('amount <= ?',
                                                     @params[:max]))
      elsif @params[:min].present?
        @spendings = @spendings.where('amount >= ?', @params[:min])
      elsif @params[:max].present?
        @spendings = @spendings.where('amount <= ?', @params[:max])
      end

      @spendings
    end

    # rubocop:enable Metrics/AbcSize

    def filter_by_category
      if @params[:category].present?
        category = Category.find_by(heading: @params[:category])
        @spendings = @spendings.where(category_id: category.id)
      else
        @spendings
      end

      @spendings
    end
  end
end
