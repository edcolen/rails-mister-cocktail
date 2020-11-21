class Review < ApplicationRecord
  belongs_to :cocktail
  validates :cocktail_id, :rating, :content, presence: true
end
