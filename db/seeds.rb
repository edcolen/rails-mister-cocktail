drink_count = 0

puts 'Creating main user...'
puts ''
User.create!(username: 'edcolen', email: 'ed.colen@gmail.com', password: '123456')

puts 'Gathering cocktails ideas...'
sleep(1)

first_characters = (0...36).map { |i| i.to_s(36) }

# Get list of drinks by first letter
first_characters.each do |letter|
  puts "=== Mixed #{drink_count} cocktails till now... ==="
  drinks_url = "https://www.thecocktaildb.com/api/json/v1/1/search.php?f=#{letter}"

  drinks = JSON.parse(open(drinks_url).read)['drinks']
  next if drinks.nil?

  drinks.each do |drink|
    next if drink.nil?

    # Create cocktail
    puts '=================='
    puts "Mixing a #{drink['strDrink']}"
    drink_user_id = User.first.id
    drink_name = drink['strDrink']
    drink_category = drink['strCategory'].downcase
    drink_instructions = drink['strInstructions']
    drink_glass = drink['strGlass'].downcase
    drink_alcoholic = drink['strAlcoholic'].downcase
    drink_mixed_by_user = false
    drink_thumb = drink['strDrinkThumb']
    cocktail = Cocktail.create!(user_id: drink_user_id,
                                name: drink_name,
                                category: drink_category,
                                instructions: drink_instructions,
                                glass: drink_glass,
                                alcoholic: drink_alcoholic,
                                mixed_by_user: drink_mixed_by_user)

    # Attach image to cocktail
    drink_name_no_spaces = drink_name.gsub(' ', '_')
    image = URI.open(drink_thumb)
    cocktail.photo.attach(io: image,
                          filename: drink_name_no_spaces,
                          content_type: 'image/png')
    drink_count += 1

    # Get cocktail ingredients
    ingredient_counter = 1
    while ingredient_counter <= 15
      drink_ingredient_name = drink["strIngredient#{ingredient_counter}"]
      drink_ingredient_measure = drink["strMeasure#{ingredient_counter}"]
      ingredient_counter += 1
      next if drink_ingredient_name.nil?

      drink_ingredient_name_to_url = drink_ingredient_name.gsub(' ', '%20')

      # Get ingredient details
      ingredient_url = "https://www.thecocktaildb.com/api/json/v1/1/search.php?i=#{drink_ingredient_name}"
      drink_ingredient = JSON.parse(open(ingredient_url).read)['ingredients']
      ingredient_user_id = User.first.id
      ingredient_description = drink_ingredient['strDescription']
      ingredient_type = drink_ingredient['strType'].downcase
      ingredient_alcoholic = drink_ingredient['strAlcohol'].downcase
      ingredient_abv = drink_ingredient['strABV'].downcase
      ingredient_added_by_user = false

      ingredient = Ingredient.create(user_id: ingredient_user_id,
                                     name: ingredient_user_id,
                                     description: ingredient_description,
                                     type: ingredient_type,
                                     alcoholic: ingredient_alcoholic,
                                     abv: ingredient_abv,
                                     added_by_user: ingredient_added_by_user)

      # Attach image to ingredient
      drink_ingredient_name_to_url_no_spaces = drink_ingredient_name.gsub(' ', '_')
      ingredient_image = URI.open("https://www.thecocktaildb.com/images/ingredients/#{drink_ingredient_name_to_url}.png")

      drink_ingredient.photo.attach(io: ingredient_image,
                                    filename: drink_ingredient_name_to_url_no_spaces,
                                    content_type: 'image/png')

      # Create a dose for the ingredient
      Dose.create!(cocktail_id: cocktail.id,
                   ingredient_id: ingredient.id,
                   measure: drink_ingredient_measure)

    end
  end
end
