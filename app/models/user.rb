class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  has_secure_password
  validates :email, format: {with: VALID_EMAIL_REGEX},
    presence: true,
    length: {maximum: Settings.maximum_email},
    uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.minimum_password}
  validates :name, presence: true,
    length: {maximum: Settings.maximum_name}
  before_save ->{email.downcase!}
end
