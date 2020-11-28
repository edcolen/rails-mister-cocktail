class Ingredient < ApplicationRecord
  belongs_to :user
  has_many :doses

  has_one_attached :photo

  validates :name, uniqueness: true,
                   presence: true
  validates :description, presence: true,
                          length: { minimum: 30,
                                    too_short: `description should be at least %<count> characters long` }
  validates :type, presence: true
  validates :alcoholic, presence: true
  validates :abv, presence: true
  validates :added_by_user, presence: true
end
