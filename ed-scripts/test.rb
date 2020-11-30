require 'set'
require 'open-uri'
require 'json'
require 'i18n'
I18n.available_locales = [:en]

ingredient_names = File.join(__dir__, '/cocktail_db/ingredient_names.txt')
File.foreach(ingredient_names) do |ingredient_name|
  p ingredient_name.chomp
  transliterated_ingredient_name = I18n.transliterate(ingredient_name.chomp)

  ingredient_url = "https://www.thecocktaildb.com/api/json/v1/1/search.php?i=#{transliterated_ingredient_name}"
  p ingredient_url

  drink_ingredient = JSON.parse(open(ingredient_url).read)['ingredients'].first
  next if drink_ingredient.nil?

  ingredient_description = drink_ingredient['strDescription'] || 'Description not available at the moment.'

  p ingredient_description
end
