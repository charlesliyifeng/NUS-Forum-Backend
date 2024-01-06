class User < ApplicationRecord
  has_many :questions, dependent: :nullify
  has_many :answers, dependent: :nullify

  has_secure_password
  PASSWORD_REQUIREMENTS = /\A
    (?=.{8,}) # at least 8 chars long
    (?=.*\d) # contain at least one number
    (?=.*[a-z]) # contain at least one lowercase letter
    (?=.*[A-Z]) # contain at least one uppercase letter
  /x
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, format: PASSWORD_REQUIREMENTS
  auto_strip_attributes :name, nullify: false, squish: true
  auto_strip_attributes :email
end
