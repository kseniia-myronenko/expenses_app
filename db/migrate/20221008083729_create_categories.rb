class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories, id: :uuid do |t|
      t.string :heading
      t.text :body
      t.boolean :display
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
