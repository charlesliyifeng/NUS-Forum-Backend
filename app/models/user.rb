class User < ApplicationRecord
  has_secure_password
  PASSWORD_REQUIREMENTS = /\A
    (?=.{8,}) # at least 8 chars long
    (?=.*\d) # contain at least one number
    (?=.*[a-z]) # contain at least one lowercase letter
    (?=.*[A-Z]) # contain at least one uppercase letter
  /x
  validates :email, presence: true, uniqueness: true
  validates :password, format: PASSWORD_REQUIREMENTS

  has_many :questions, dependent: :nullify
  has_many :answers, dependent: :nullify

end
