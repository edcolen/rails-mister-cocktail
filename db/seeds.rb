drink_count = 0

puts 'Creating main user...'
puts ''
User.create!(username: 'edcolen', email: 'ed.colen@gmail.com', password: '123456')

puts 'Gathering cocktails ideas...'
sleep(1)

# Get list of drinks by first letter

('a'..'z').to_a.each do |letter|
  puts "Mixed #{drink_count} cocktails till now..."
  drinks_url = "https://www.thecocktaildb.com/api/json/v1/1/search.php?f=#{letter}"

  drinks = JSON.parse(open(drinks_url).read)['drinks']
  next if drinks.nil?

  drinks.each do |drink|
    next if drink.nil?

    puts "Mixing a #{drink['strDrink']}"
    drink_count += 1
  end
end

# Get list of drinks by first letter

(0..9).to_a.each do |letter|
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
    drink_category = drink['strCategory']
    drink_instructions = drink['strInstructions']
    drink_glass = drink['strGlass']
    drink_alcoholic = drink['strAlcoholic'] == 'Alcoholic'
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
      ingredient_type = drink_ingredient['strType']
      ingredient_alcoholic = drink_ingredient['strAlcohol'] == 'Yes'
      ingredient_added_by_user = false
      ingredient_abv = drink_ingredient['strABV'].to_f

      ingredient = Ingredient.create(name: drink_ingredient_name)

      # Attach image to ingredient
      drink_ingredient_name_to_url_no_spaces = drink_ingredient_name.gsub(' ', '_')
      ingredient_image = URI.open("https://www.thecocktaildb.com/images/ingredients/#{drink_ingredient_name_to_url}.png")

      drink_ingredient.photo.attach(io: ingredient_image,
                                    filename: drink_ingredient_name_to_url_no_spaces,
                                    content_type: 'image/png')
    end
  end
end

# puts 'Gathering drinks ideas...'

# drink_id = 11_120

# while Cocktail.count < 601
#   puts "Now at #{drink_id}"
#   drink_url = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php?i=#{drink_id}"
#   drink_id += 1

#   drink = JSON.parse(open(drink_url).read)['drinks']
#   next if drink.nil?

#   puts "Mixing a #{drink[0]['strDrink']}"
#   drink_name = drink[0]['strDrink']
#   drink_category = drink[0]['strCategory']
#   drink_alcoholic = drink[0]['strAlcoholic']
#   drink_glass = drink[0]['strGlass']
#   drink_instructions = drink[0]['strInstructions']
#   drink_thumb = drink[0]['strDrinkThumb']
#   cocktail = Cocktail.create(name: drink_name,
#                              category: drink_category,
#                              alcoholic: drink_alcoholic,
#                              glass: drink_glass,
#                              instructions: drink_instructions)
#   image = URI.open(drink_thumb)
#   cocktail.photo.attach(io: image, filename: drink_name, content_type: 'image/png')

#   puts 'Generating some ratings...'
#   rand(5..20).times do
#     Review.create(rating: rand(0..5))
#   end

#   puts 'Adding ingredients to database...'
#   ing_counter = 1
#   while ing_counter <= 15
#     drink_ingredient_name = drink[0]["strIngredient#{ing_counter}"]
#     ing_counter += 1
#     next if drink_ingredient_name.nil?

#     drink_ingredient_to_url = drink_ingredient_name.gsub(' ', '%20')
#     drink_ingredient_no_spaces = drink_ingredient_name.gsub(' ', '_')
#     ingredient_image = URI.open("https://www.thecocktaildb.com/images/ingredients/#{drink_ingredient_to_url}.png")
#     drink_ingredient = Ingredient.create(name: drink_ingredient_name)

#     drink_ingredient.photo.attach(io: ingredient_image, filename: drink_ingredient_no_spaces, content_type: 'image/png')
#   end
# end

# ###############################
# OLD SEED
# require 'faker'

# url = 'https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list'
# ingredients_string = open(url).read
# ingredients = JSON.parse(ingredients_string)

# puts 'Creating ingredients...'
# sleep(1)

# ingredients['drinks'].each do |ingredient|
#   created_ingredient = Ingredient.create!(name: ingredient['strIngredient1'])
#   puts "#{created_ingredient.name} created."
# end
# Ingredient.create!(name: 'Cachaça')
# puts 'Cachaça created.'

# puts 'Ingredients successfully created!'
# puts ''

# puts 'Preparing some drinks...'
# sleep(1)

# drink_names = ['Old Fashioned',
#                'Margarita',
#                'Cosmopolitan',
#                'Negroni',
#                'Moscow Mule',
#                'Martini',
#                'Mojito',
#                'Whiskey Sour',
#                'French 75',
#                'Manhattan',
#                'Spritz',
#                'Gimlet',
#                'Sazerac',
#                'Pimm\'s Cup',
#                'Mimosa',
#                'Paloma',
#                'Sidecar',
#                'Mint Julep',
#                'Daiquiri',
#                'Dark & Stormy',
#                'Martinez']

# drinks_urls = ['https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/old-fashioned-1592951230.jpg',
#                'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/margarita-1592951298.jpg',
#                'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/cosmopolitan-1592951320.jpg',
#                'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/negroni-1592951342.jpg',
#                'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/moscow-mule-1592951361.jpg',
#                'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/martini-1592951711.jpg',
#                'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/mojito-1592951385.jpg',
#                'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/whiskey-sour-1592951408.jpg',
#                'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/french-75-1592951630.jpg',
#                'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/manhattan-1592951428.jpg',
#                'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/milano-spritzer-1593008325.jpg',
#                'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/gimlet-1592951479.jpg',
#                'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/sazerac-1592951496.jpg',
#                'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/pimms-cup-1592951518.jpg',
#                'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/mimosa-1592951449.jpg',
#                'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/paloma-1592951544.jpg',
#                'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/sidecar-1592951563.jpg',
#                'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/mint-julep-1592951594.jpg',
#                'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/daiquiri-1592951739.jpg',
#                'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/dark-n-stormy-1592951763.jpg',
#                'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/martinez-1592951796.jpg']

# drink_names.each_with_index do |name, index|
#   cocktail = Cocktail.create!(name: name)
#   image = URI.open(drinks_urls[index])
#   cocktail.photo.attach(io: image, filename: cocktail.name, content_type: 'image/png')

#   puts "Mixing a #{cocktail.name}..."
# end

# puts 'Drinks successfully mixed!'
# puts ''

# puts 'Preparing some doses...'
# sleep(1)

# quantities = ['3 spoons', '200ml', '100ml', '30ml', '2 leaves']

# 50.times do
#   cocktail = Cocktail.all.sample
#   ingredient = Ingredient.all.sample
#   description = quantities.sample

#   Dose.create(description: description,
#               cocktail: cocktail,
#               ingredient: ingredient)
# end

# puts 'Doses successfully created!'
# puts ''

# puts 'Writing some reviews'
# sleep(1)

# 40.times do
#   cocktail = Cocktail.all.sample
#   content = Faker::ChuckNorris.fact
#   rating = (1..5).to_a.sample
#   Review.create!(content: content,
#                  rating: rating,
#                  cocktail: cocktail)
# end

# puts 'Reviews successfully created!'
# puts ''

# puts 'Seed successfully created!'
