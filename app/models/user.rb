class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :friends
  has_many :posts
  has_many :comments
  # has_many :messages
  # has_many :friends

  # Validations
  validates :username, :email, presence: true
end
