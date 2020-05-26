class User < ApplicationRecord
  before_email{email.downcase!}
  VALID_EMAIL_REGEX = "/\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i".freeze
  validates :name, presence: true, length: {minimum: settings.name_minimum}
  validates :email, presence: true, length: {maximum: email_maximum},
  format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  has_scure_password
  validates :password, length: {minimum: password_minimum}
end
