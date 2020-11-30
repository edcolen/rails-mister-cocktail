class Ingredient < ApplicationRecord
  belongs_to :user
  has_many :doses

  has_one_attached :photo

  validates :name, uniqueness: true,
                   presence: true
  validates :description, presence: true,
                          length: { minimum: 20,
                                    too_short: `description should be at least %<count> characters long` }
  validates :ingredient_type, presence: true
  validates :alcoholic, presence: true
  validates :abv, presence: true
end
