class Dose < ApplicationRecord
  belongs_to :cocktail
  belongs_to :ingredient

  validates :ingredient_id, presence: true
  validates :cocktail_id, presence: true,
                          uniqueness: { scope: :ingredient_id,
                                        message: 'this cocktail already has this ingredient' }
  validates :measure, presence: true,
                      length: { minimum: 30,
                                too_short: `measure should be at least %<count> characters long` }
end
