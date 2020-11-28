# ################################################################
# Scripts for getting DB info
# ################################################################
require 'csv'
require 'set'
require 'open-uri'
require 'json'
require 'i18n'

# Setting information storage
cocktail_categories_csv_file = File.join(__dir__, 'cocktail_categories.csv')
cocktail_glasses_csv_file = File.join(__dir__, 'cocktail_glasses.csv')
cocktail_alcoholics_csv_file = File.join(__dir__, 'cocktail_alcoholics.csv')
cocktail_names_csv_file = File.join(__dir__, 'cocktail_names.csv')

def save_to_csv(file, objects)
  CSV.open(file, 'wb') do |row|
    row << objects
  end
end

# Getting cocktails info

# first_characters = (0...36).map { |i| i.to_s(36) }
cocktail_names = []
categories = [].to_set
glasses = [].to_set
alcoholics = [].to_set

('a'..'b').each do |letter|
  drinks_url = "https://www.thecocktaildb.com/api/json/v1/1/search.php?f=#{letter}"
  drinks = JSON.parse(open(drinks_url).read)['drinks']
  next if drinks.nil?

  puts "Found #{drinks.length} drinks with #{letter}"

  drinks.each do |drink|
    next if drink.nil?

    puts '=================='
    puts "Getting info from #{drink['strDrink']}"
    drink_name = drink['strDrink'] ? drink['strDrink'].downcase : 'unknown'
    drink_category = drink['strCategory'] ? drink['strCategory'].downcase : 'unknown'
    drink_glass = drink['strGlass'] ? drink['strGlass'].downcase : 'unknown'
    drink_alcoholic = drink['strAlcoholic'] ? drink['strAlcoholic'].downcase : 'unknown'

    categories.add(drink_category)
    glasses.add(drink_glass)
    alcoholics.add(drink_alcoholic)
    cocktail_names << drink_name
  end
end

puts '============================================='
puts "Got #{cocktail_names.length} drinks"
puts 'Saving names to csv...'
save_to_csv(cocktail_names_csv_file, cocktail_names.to_a.sort)

puts '============================================='
puts "#{categories.length} categories found:"
p categories
puts 'Saving categories to csv...'
save_to_csv(cocktail_categories_csv_file, categories.to_a.sort)

puts '============================================='
puts "#{glasses.length} glasses found:"
p glasses
puts 'Saving glasses to csv...'
save_to_csv(cocktail_glasses_csv_file, glasses.to_a.sort)

puts '============================================='
puts "#{alcoholics.length} alcoholics categories found:"
p alcoholics
puts 'Saving alcoholics to csv...'
save_to_csv(cocktail_alcoholics_csv_file, alcoholics.to_a.sort)

# ################################################################
# Getting ingredients info
# ################################################################

# I18n.available_locales = [:en]

# first_characters = (0...36).map { |i| i.to_s(36) }
# total_ingredient_count = 0
# total_ingredients_names = []

# ingredients_types = [].to_set
# ingredients_alcoholics = [].to_set
# ingredients_abvs = [].to_set
# ingredients_measures = [].to_set

# # Get list of drinks by first letter
# first_characters.each do |letter|
#   drinks_url = "https://www.thecocktaildb.com/api/json/v1/1/search.php?f=#{letter}"

#   drinks = JSON.parse(open(drinks_url).read)['drinks']
#   next if drinks.nil?

#   drinks.each do |drink|
#     next if drink.nil?

#     # Create cocktail
#     puts '=================='
#     puts "Getting info from #{drink['strDrink']}"

#     # Get cocktail ingredients
#     ingredient_counter = 1
#     while ingredient_counter <= 15
#       drink_ingredient_name = drink["strIngredient#{ingredient_counter}"]
#       drink_ingredient_measure = drink["strMeasure#{ingredient_counter}"]
#       ingredient_counter += 1
#       next if drink_ingredient_name.nil?

#       # Get ingredient details
#       puts "Looking for #{drink_ingredient_name}"
#       transliterated_ingredient_name = I18n.transliterate(drink_ingredient_name)
#       ingredient_url = "https://www.thecocktaildb.com/api/json/v1/1/search.php?i=#{transliterated_ingredient_name}"
#       p ingredient_url
#       drink_ingredient = JSON.parse(open(ingredient_url).read)['ingredients'].first
#       next if drink_ingredient.nil?

#       ingredient_type = drink_ingredient['strType'] ? drink_ingredient['strType'].downcase : 'unknown'
#       ingredient_alcoholic = drink_ingredient['strAlcohol'] ? drink_ingredient['strAlcohol'].downcase : 'unknown'
#       ingredient_abv = drink_ingredient['strABV'] ? drink_ingredient['strABV'].downcase : 'unknown'

#       total_ingredient_count += 1
#       total_ingredients_names.push(drink_ingredient_name)

#       ingredients_types.add(ingredient_type)
#       ingredients_alcoholics.add(ingredient_alcoholic)
#       ingredients_abvs.add(ingredient_abv)
#       ingredients_measures.add(drink_ingredient_measure)
#     end
#   end
# end

# puts '==============================================='
# puts "#{total_ingredients_names.length} ingredients found"
# p total_ingredients_names
# puts '==============================================='
# puts "#{ingredients_types.length} Types of ingredients:"
# p ingredients_types
# puts '==============================================='
# puts "#{ingredient_alcoholic.length} Ingredients alcoholics:"
# p ingredients_alcoholics
# puts '==============================================='
# puts "#{ingredients_abvs.length} Ingredients abvs:"
# p ingredients_abvs
