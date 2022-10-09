class CreateSpendings < ActiveRecord::Migration[7.0]
  def change
    create_table :spendings, id: :uuid do |t|
      t.integer :amount
      t.text :description
      t.references :category, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
