class AddDeafaultToCategories < ActiveRecord::Migration[7.0]
  change_column_default(
    :categories,
    :display,
    true
  )
end
