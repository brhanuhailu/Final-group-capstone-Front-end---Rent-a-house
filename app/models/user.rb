class User < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  include DeviseTokenAuth::Concerns::User
  has_many :houses
  has_many :reservations
  validates :username, :email, presence: true
end
