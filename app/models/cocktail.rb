class Cocktail < ApplicationRecord
  belongs_to :user
  has_many :doses, dependent: :destroy
  has_many :ingredients, through: :doses
  has_many :reviews, dependent: :destroy

  has_one_attached :photo

  validates :name, uniqueness: true,
                   presence: true
  validates :category, presence: true,
                       inclusion: { in: ['cocktail', 'shot', 'beer',
                                         'milk / float / shake',
                                         'ordinary drink',
                                         'other/unknown', 'coffee / tea',
                                         'punch / party drink',
                                         'soft drink / soda',
                                         'homemade liqueur', 'cocoa'] }
  validates :instructions, presence: true,
                           length: { minimum: 30,
                                     too_short: `instructions should be at least %<count> characters long` }
  validates :glass, presence: true,
                    inclusion: { in: ['white wine glass', 'old-fashioned glass',
                                      'beer glass', 'beer mug', 'shot glass',
                                      'collins glass', 'highball glass',
                                      'cocktail glass', 'martini glass',
                                      'whiskey sour glass', 'champagne flute',
                                      'margarita glass', 'beer pilsner',
                                      'coupe glass', 'punch bowl', 'coffee mug',
                                      'pint glass', 'hurricane glass', 'pitcher',
                                      'irish coffee cup', 'mason jar',
                                      'balloon glass', 'wine glass',
                                      'cordial glass', 'brandy snifter',
                                      'copper mug', 'nick and nora glass',
                                      'pousse cafe glass',
                                      'margarita/coupette glass'] }
  validates :alcoholic, uniqueness: true,
                        presence: true,
                        inclusion: { in: ['alcoholic', 'non alcoholic',
                                          'optional alcohol'] }
  validates :mixed_by_user, presence: true
end
