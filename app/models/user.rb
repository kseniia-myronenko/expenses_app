class User < ApplicationRecord
  has_secure_password

  USERNAME_MIN_LENGTH = 3
  USERNAME_MAX_LENGTH = 50
  PASSWORD_MIN_LENGTH = 8
  PASSWORD_REGEXP = /\A[a-zA-Z0-9]*.{8,}\z/

  has_many :categories, dependent: :destroy
  has_many :spendings, dependent: :destroy

  validates :username, :password, presence: true
  validates :username,
            uniqueness: { case_sensitive: false,
                          message: I18n.t('activerecord.errors.models.user.attributes.username.already_exists') }
  validates :username, length: { in: USERNAME_MIN_LENGTH..USERNAME_MAX_LENGTH }
  validates :password, length: { minimum: PASSWORD_MIN_LENGTH }
  validates :password, format: { with: PASSWORD_REGEXP }
end
