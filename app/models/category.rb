class Category < ApplicationRecord
  LIMIT = 3

  belongs_to :user
  has_many :spendings, dependent: :destroy

  validates :heading, presence: true
  validate :unique_category_name

  def unique_category_name
    unique_category = Category.where(heading:, user_id:).where.not(id:)

    errors.add(:heading, :already_exists) if unique_category.exists?
  end
end
