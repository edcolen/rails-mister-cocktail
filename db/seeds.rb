puts 'Creating main user...'
puts ''

User.create!(username: 'edcolen', email: 'ed.colen@gmail.com', password: '123456')
user = User.first

# Create ingredients
puts 'Creating some ingredients...'

ingredient_names = "#{Rails.root}/ed-scripts/cocktail_db/ingredient_names.txt"
File.foreach(ingredient_names) do |ingredient_name|
  # Get ingredient details
  transliterated_ingredient_name = I18n.transliterate(ingredient_name.chomp)

  ingredient_url = "https://www.thecocktaildb.com/api/json/v1/1/search.php?i=#{transliterated_ingredient_name}"

  drink_ingredient = JSON.parse(open(ingredient_url).read)['ingredients'].first
  next if drink_ingredient.nil?

  ingredient_description = drink_ingredient['strDescription'] || 'Description not available at the moment.'
  ingredient_type = drink_ingredient['strType'] ? drink_ingredient['strType'].downcase : 'unknown'
  ingredient_alcoholic = drink_ingredient['strAlcohol'] ? drink_ingredient['strAlcohol'].downcase : 'unknown'
  ingredient_abv = drink_ingredient['strABV'] ? drink_ingredient['strABV'].downcase : 'unknown'

  ingredient = Ingredient.create!(user_id: user.id,
                                  name: ingredient_name.chomp.capitalize,
                                  description: ingredient_description,
                                  ingredient_type: ingredient_type,
                                  alcoholic: ingredient_alcoholic,
                                  abv: ingredient_abv,
                                  added_by_user: false)

  puts "Got some #{ingredient.name}"

  # Attach image to ingredient
  drink_ingredient_name_to_filename = transliterated_ingredient_name.gsub(' ', '_')
  drink_ingredient_name_to_url = transliterated_ingredient_name.gsub(' ', '%20')
  ingredient_image = URI.open("https://www.thecocktaildb.com/images/ingredients/#{drink_ingredient_name_to_url}.png")

  ingredient.photo.attach(io: ingredient_image,
                          filename: drink_ingredient_name_to_filename,
                          content_type: 'image/png')
end

puts 'Gathering cocktails ideas...'
sleep(1)

drink_count = 0
first_characters = (0...36).map { |i| i.to_s(36) }

# Get list of drinks by first letter
first_characters.each do |letter|
  drinks_url = "https://www.thecocktaildb.com/api/json/v1/1/search.php?f=#{letter}"

  drinks = JSON.parse(open(drinks_url).read)['drinks']
  next if drinks.nil?

  puts "Found #{drinks.length} drinks with #{letter}"

  drinks.each do |drink|
    next if drink.nil?

    # Create cocktail
    puts '=================='
    puts "Mixing a #{drink['strDrink']}"

    drink_name = drink['strDrink'] ? drink['strDrink'].downcase : 'unknown'
    transliterated_drink_name = I18n.transliterate(drink_name.chomp)
    drink_category = drink['strCategory'] ? drink['strCategory'].downcase : 'unknown'
    drink_glass = drink['strGlass'] ? drink['strGlass'].downcase : 'unknown'
    drink_alcoholic = drink['strAlcoholic'] ? drink['strAlcoholic'].downcase : 'unknown'
    drink_instructions = drink['strInstructions'].nil? || drink['strInstructions'] == '' ? 'Instructions not available at the moment.' : drink['strInstructions']
    drink_thumb = drink['strDrinkThumb']

    cocktail = Cocktail.create!(user_id: user.id,
                                name: transliterated_drink_name.capitalize,
                                category: drink_category,
                                instructions: drink_instructions,
                                glass: drink_glass,
                                alcoholic: drink_alcoholic,
                                mixed_by_user: false)

    # Attach image to cocktail
    drink_name_to_filename = drink_name.gsub(' ', '_')
    image = URI.open(drink_thumb)
    cocktail.photo.attach(io: image,
                          filename: drink_name_to_filename,
                          content_type: 'image/png')
    drink_count += 1

    # Get cocktail ingredients
    ingredient_counter = 1

    while ingredient_counter <= 15
      drink_ingredient_name = drink["strIngredient#{ingredient_counter}"]
      drink_ingredient_measure = drink["strMeasure#{ingredient_counter}"]

      ingredient_counter += 1
      next if drink_ingredient_name.nil? || drink_ingredient_name == ''

      puts "Putting #{drink_ingredient_measure} #{drink_ingredient_name} into the #{cocktail.name}"

      drink_ingredient_name = 'whisky' if drink_ingredient_name == 'Whiskey'
      drink_ingredient_measure = 'unknown' if drink_ingredient_measure.nil? || drink_ingredient_measure == "\n"

      drink_ingredient = Ingredient.find_by(name: drink_ingredient_name.capitalize)
      puts "Found #{drink_ingredient.name} at the database."

      # Create a dose for the ingredient
      Dose.create!(cocktail_id: cocktail.id,
                   ingredient_id: drink_ingredient.id,
                   measure: drink_ingredient_measure)
    end
  end
  puts "===== Mixed #{drink_count} cocktails till now... ====="
end

puts ''
puts ''
puts ''
puts ''
puts ''
puts ''
puts ''
puts ''
puts '============================================'
puts 'Seed successfully complete!'
puts '============================================'
puts "#{Ingredient.count} ingredients available."
puts "#{Cocktail.count} cocktails mixed."
