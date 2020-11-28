class Cocktail < ApplicationRecord
  has_one_attached :photo
  has_many :doses, dependent: :destroy
  has_many :ingredients, through: :doses
  has_many :reviews, dependent: :destroy

  validates :name, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true
  validates :category, :instructions, :glass, presence: true
end
