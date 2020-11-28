# drink_count = 0

# puts 'Creating main user...'
# puts ''
# User.create!(username: 'edcolen', email: 'ed.colen@gmail.com', password: '123456')

# puts 'Gathering cocktails ideas...'
# sleep(1)

# first_characters = (0...36).map { |i| i.to_s(36) }

# # Get list of drinks by first letter
# first_characters.each do |letter|
#   puts "=== Mixed #{drink_count} cocktails till now... ==="
#   drinks_url = "https://www.thecocktaildb.com/api/json/v1/1/search.php?f=#{letter}"

#   drinks = JSON.parse(open(drinks_url).read)['drinks']
#   next if drinks.nil?

#   drinks.each do |drink|
#     next if drink.nil?

#     # Create cocktail
#     puts '=================='
#     puts "Mixing a #{drink['strDrink']}"
#     drink_user_id = User.first.id
#     drink_name = drink['strDrink']
#     drink_category = drink['strCategory'].downcase
#     drink_instructions = drink['strInstructions']
#     drink_glass = drink['strGlass'].downcase
#     drink_alcoholic = drink['strAlcoholic'].downcase
#     drink_mixed_by_user = false
#     drink_thumb = drink['strDrinkThumb']
#     cocktail = Cocktail.create!(user_id: drink_user_id,
#                                 name: drink_name,
#                                 category: drink_category,
#                                 instructions: drink_instructions,
#                                 glass: drink_glass,
#                                 alcoholic: drink_alcoholic,
#                                 mixed_by_user: drink_mixed_by_user)

#     # Attach image to cocktail
#     drink_name_no_spaces = drink_name.gsub(' ', '_')
#     image = URI.open(drink_thumb)
#     cocktail.photo.attach(io: image,
#                           filename: drink_name_no_spaces,
#                           content_type: 'image/png')
#     drink_count += 1

#     # Get cocktail ingredients
#     ingredient_counter = 1
#     while ingredient_counter <= 15
#       drink_ingredient_name = drink["strIngredient#{ingredient_counter}"]
#       drink_ingredient_measure = drink["strMeasure#{ingredient_counter}"]
#       ingredient_counter += 1
#       next if drink_ingredient_name.nil?

#       drink_ingredient_name_to_url = drink_ingredient_name.gsub(' ', '%20')

#       # Get ingredient details
#       ingredient_url = "https://www.thecocktaildb.com/api/json/v1/1/search.php?i=#{drink_ingredient_name}"
#       drink_ingredient = JSON.parse(open(ingredient_url).read)['ingredients']
#       ingredient_user_id = User.first.id
#       ingredient_description = drink_ingredient['strDescription']
#       ingredient_type = drink_ingredient['strType'].downcase
#       ingredient_alcoholic = drink_ingredient['strAlcohol'].downcase
#       ingredient_abv = drink_ingredient['strABV'].downcase
#       ingredient_added_by_user = false

#       ingredient = Ingredient.create(user_id: ingredient_user_id,
#                                      name: ingredient_user_id,
#                                      description: ingredient_description,
#                                      type: ingredient_type,
#                                      alcoholic: ingredient_alcoholic,
#                                      abv: ingredient_abv,
#                                      added_by_user: ingredient_added_by_user)

#       # Attach image to ingredient
#       drink_ingredient_name_to_url_no_spaces = drink_ingredient_name.gsub(' ', '_')
#       ingredient_image = URI.open("https://www.thecocktaildb.com/images/ingredients/#{drink_ingredient_name_to_url}.png")

#       drink_ingredient.photo.attach(io: ingredient_image,
#                                     filename: drink_ingredient_name_to_url_no_spaces,
#                                     content_type: 'image/png')

#       # Create a dose for the ingredient
#       Dose.create!(cocktail_id: cocktail.id,
#                    ingredient_id: ingredient.id,
#                    measure: drink_ingredient_measure)

#     end
#   end
# end

#################################################################
# Scripts for getting DB info
#################################################################

#################################################################
# Getting cocktails info
#################################################################
# first_characters = (0...36).map { |i| i.to_s(36) }
# drink_names = []
# categories = [].to_set
# glasses = [].to_set
# alcoholics = [].to_set

# drink_count = 0

# first_characters.each do |letter|
#   drinks_url = "https://www.thecocktaildb.com/api/json/v1/1/search.php?f=#{letter}"
#   drinks = JSON.parse(open(drinks_url).read)['drinks']
#   next if drinks.nil?

#   puts "#{drinks.length} drinks with #{letter}"

#   drinks.each do |drink|
#     next if drink.nil?

#     puts '=================='
#     puts "Getting info from #{drink['strDrink']}"
#     drink_count += 1
#     drink_name = drink['strDrink'].downcase
#     drink_category = drink['strCategory'].downcase
#     drink_glass = drink['strGlass'].downcase
#     drink_alcoholic = drink['strAlcoholic'].downcase

#     categories.add(drink_category)
#     glasses.add(drink_glass)
#     alcoholics.add(drink_alcoholic)
#     drink_names << drink_name
#   end
# end

# puts '============================================='
# puts "Got #{drink_names.length} drinks"
# puts "Counter says #{drink_count}"
# puts '============================================='
# puts "#{categories.length} Categories:"
# p categories
# puts '============================================='
# puts "#{glasses.length} Glasses:"
# p glasses
# puts '============================================='
# puts "#{alcoholics.length} Alcoholics:"
# p alcoholics

#################################################################
# Getting ingredients info
#################################################################
require 'i18n'
I18n.available_locales = [:en]

first_characters = (0...36).map { |i| i.to_s(36) }
drink_count = 0
total_ingredient_count = 0
total_ingredients_names = []

ingredients_types = [].to_set
ingredients_alcoholics = [].to_set
ingredients_abvs = [].to_set
ingredients_measures = [].to_set

# Get list of drinks by first letter
first_characters.each do |letter|
  drinks_url = "https://www.thecocktaildb.com/api/json/v1/1/search.php?f=#{letter}"

  drinks = JSON.parse(open(drinks_url).read)['drinks']
  next if drinks.nil?

  drinks.each do |drink|
    next if drink.nil?

    # Create cocktail
    puts '=================='
    puts "Getting info from #{drink['strDrink']}"

    # Get cocktail ingredients
    ingredient_counter = 1
    while ingredient_counter <= 15
      drink_ingredient_name = drink["strIngredient#{ingredient_counter}"]
      drink_ingredient_measure = drink["strMeasure#{ingredient_counter}"]
      ingredient_counter += 1
      next if drink_ingredient_name.nil?

      # Get ingredient details
      puts "Looking for #{drink_ingredient_name}"
      transliterated_ingredient_name = I18n.transliterate(drink_ingredient_name)
      ingredient_url = "https://www.thecocktaildb.com/api/json/v1/1/search.php?i=#{transliterated_ingredient_name}"
      p ingredient_url
      drink_ingredient = JSON.parse(open(ingredient_url).read)['ingredients'].first
      next if drink_ingredient.nil?

      ingredient_type = drink_ingredient['strType'] ? drink_ingredient['strType'].downcase : 'unknown'
      ingredient_alcoholic = drink_ingredient['strAlcohol'] ? drink_ingredient['strAlcohol'].downcase : 'unknown'
      ingredient_abv = drink_ingredient['strABV'] ? drink_ingredient['strABV'].downcase : 'unknown'

      total_ingredient_count += 1
      total_ingredients_names.push(drink_ingredient_name)

      ingredients_types.add(ingredient_type)
      ingredients_alcoholics.add(ingredient_alcoholic)
      ingredients_abvs.add(ingredient_abv)
      ingredients_measures.add(drink_ingredient_measure)
    end
  end
end

puts '==============================================='
puts "#{total_ingredients_names.length} ingredients found"
p total_ingredients_names
puts '==============================================='
puts "#{ingredients_types.length} Types of ingredients:"
p ingredients_types
puts '==============================================='
puts "#{ingredient_alcoholic.length} Ingredients alcoholics:"
p ingredients_alcoholics
puts '==============================================='
puts "#{ingredients_abvs.length} Ingredients abvs:"
p ingredients_abvs
