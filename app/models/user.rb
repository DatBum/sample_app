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

  def self.digest string
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create string, cost: cost
  end
end
