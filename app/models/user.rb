class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :cocktails, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :ingredients, dependent: :destroy

  validates :username, :email, :password, presence: true
end
