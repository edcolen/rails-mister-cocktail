# ################################################################
# Scripts for getting DB info
# ################################################################
require 'set'
require 'open-uri'
require 'json'
require 'i18n'
I18n.available_locales = [:en]

# Setting information storage
cocktail_names_list = File.join(__dir__, 'cocktail_names.txt')
cocktail_categories_list = File.join(__dir__, 'cocktail_categories.txt')
cocktail_glasses_list = File.join(__dir__, 'cocktail_glasses.txt')
cocktail_alcoholics_list = File.join(__dir__, 'cocktail_alcoholics.txt')
ingredient_names_list = File.join(__dir__, 'ingredient_names.txt')
ingredient_types_list = File.join(__dir__, 'ingredient_types.txt')
ingredient_alcoholics_list = File.join(__dir__, 'ingredient_alcoholics.txt')
ingredient_abvs_list = File.join(__dir__, 'ingredient_abvs.txt')
ingredient_measures_list = File.join(__dir__, 'ingredient_measures.txt')

def save_to_file(file, objects)
  File.write(file, objects.join("\n"), mode: 'w')
end

first_characters = (0...36).map { |i| i.to_s(36) }
# Preparing info sets
cocktail_names = []
cocktail_categories = [].to_set
cocktail_glasses = [].to_set
cocktail_alcoholics = [].to_set

ingredient_names = []
ingredient_types_set = [].to_set
ingredient_alcoholics_set = [].to_set
ingredient_abvs_set = [].to_set
ingredient_measures_set = [].to_set

# Getting cocktails information
first_characters.each do |letter|
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

    cocktail_names << drink_name
    cocktail_categories.add(drink_category)
    cocktail_glasses.add(drink_glass)
    cocktail_alcoholics.add(drink_alcoholic)

    # Get cocktail's ingredients information
    ingredient_counter = 1
    while ingredient_counter <= 15
      drink_ingredient_name = drink["strIngredient#{ingredient_counter}"]
      drink_ingredient_measure = drink["strMeasure#{ingredient_counter}"] ? drink["strMeasure#{ingredient_counter}"].downcase : 'unknown'
      ingredient_counter += 1
      next if drink_ingredient_name.nil?

      next if ingredient_names.include?(drink_ingredient_name.downcase)

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

      ingredient_names.push(drink_ingredient_name.downcase)
      ingredient_types_set.add(ingredient_type)
      ingredient_alcoholics_set.add(ingredient_alcoholic)
      ingredient_abvs_set.add(ingredient_abv)
      ingredient_measures_set.add(drink_ingredient_measure)
    end
  end
end

# Organizing results
cocktail_names.sort!
cocktail_categories = cocktail_categories.to_a.sort
cocktail_glasses = cocktail_glasses.to_a.sort
cocktail_alcoholics = cocktail_alcoholics.to_a.sort

ingredient_names.sort!
ingredient_types = ingredient_types_set.to_a.sort
ingredient_alcoholics = ingredient_alcoholics_set.to_a.sort
ingredient_abvs = ingredient_abvs_set.to_a.sort
ingredient_measures = ingredient_measures_set.to_a.sort

# Printing and saving cocktail results
puts '============================================='
puts "Got #{cocktail_names.length} drinks"
puts 'Saving drink names to file...'
save_to_file(cocktail_names_list, cocktail_names.sort)

puts '============================================='
puts "#{cocktail_categories.length} categories found:"
p cocktail_categories
puts 'Saving drink categories to file...'
save_to_file(cocktail_categories_list, cocktail_categories)

puts '============================================='
puts "#{cocktail_glasses.length} glasses found:"
p cocktail_glasses
puts 'Saving glass types to file...'
save_to_file(cocktail_glasses_list, cocktail_glasses)

puts '============================================='
puts "#{cocktail_alcoholics.length} alcoholic categories found:"
p cocktail_alcoholics
puts 'Saving cocktail alcoholics categories to file...'
save_to_file(cocktail_alcoholics_list, cocktail_alcoholics)

# Printing and saving ingredient results
puts '============================================='
puts "#{ingredient_names.length} ingredients found:"
p ingredient_names
puts 'Saving ingredients names to file...'
save_to_file(ingredient_names_list, ingredient_names)
puts '============================================='

puts "#{ingredient_types.length} ingredient types found:"
p ingredient_types
puts 'Saving ingredient types to file...'
save_to_file(ingredient_types_list, ingredient_types)

puts '============================================='
puts "#{ingredient_alcoholics.length} ingredient alcoholics categories found:"
p ingredient_alcoholics
puts 'Saving ingredient alcoholics categories to file...'
save_to_file(ingredient_alcoholics_list, ingredient_alcoholics)

puts '============================================='
puts "#{ingredient_abvs.length} ingredient abvs found:"
p ingredient_abvs
puts 'Saving ingredient abvs to file...'
save_to_file(ingredient_abvs_list, ingredient_abvs)

puts '============================================='
puts "#{ingredient_measures.length} doses measures found:"
p ingredient_measures
puts 'Saving ingredient doses to file...'
save_to_file(ingredient_measures_list, ingredient_measures)

puts '============================================='
puts 'Information successfully gathered!'
puts '============================================='
