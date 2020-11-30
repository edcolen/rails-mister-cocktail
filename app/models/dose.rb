class Dose < ApplicationRecord
  belongs_to :cocktail
  belongs_to :ingredient

  validates :ingredient_id, presence: true
  validates :cocktail_id, presence: true
  validates :measure, presence: true
end
