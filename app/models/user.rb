class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true

  has_many :questions, dependent: :nullify
  has_many :answers, dependent: :nullify

end
