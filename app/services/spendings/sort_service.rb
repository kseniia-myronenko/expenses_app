module Spendings
  class SortService < ApplicationService
    ATTRIBUTES = %w[asc desc].freeze

    def initialize(spendings, params)
      @spendings = spendings
      @params = params
    end

    def call
      sorting
    end

    private

    def sorting
      if @params[:sort] && ATTRIBUTES.include?(@params[:sort].downcase)
        @spendings = @spendings.order(amount: @params[:sort])
      else
        @spendings
      end

      @spendings
    end
  end
end
