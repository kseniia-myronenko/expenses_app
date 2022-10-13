module Spendings
  class SortService < ApplicationService
    def initialize(spendings, params)
      @spendings = spendings
      @params = params
    end

    def call
      sorting
    end

    private

    def sorting
      @spendings = @params[:sort] ? @spendings.order(amount: @params[:sort]) : @spendings
    end
  end
end
