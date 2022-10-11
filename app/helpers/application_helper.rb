module ApplicationHelper
  TYPES = %w[success danger warning info].freeze

  def bootstrap_class_for(flash_type)
    TYPES.each do |item|
      next if flash_type != item

      current_style = case flash_type
                      when item
                        "alert-#{item}"
                      end
      return current_style
    end
  end
end
