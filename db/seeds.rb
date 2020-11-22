require 'faker'

url = 'https://www.thecocktaildb.com/api/json/v1/1/list.php?i=list'
ingredients_string = open(url).read
ingredients = JSON.parse(ingredients_string)

puts 'Creating ingredients...'
sleep(1)

ingredients['drinks'].each do |ingredient|
  created_ingredient = Ingredient.create!(name: ingredient['strIngredient1'])
  puts "#{created_ingredient.name} created."
end
Ingredient.create!(name: 'Cachaça')
puts 'Cachaça created.'

puts 'Ingredients successfully created!'
puts ''

puts 'Preparing some drinks...'
sleep(1)

drink_names = ['Old Fashioned',
               'Margarita',
               'Cosmopolitan',
               'Negroni',
               'Moscow Mule',
               'Martini',
               'Mojito',
               'Whiskey Sour',
               'French 75',
               'Manhattan',
               'Spritz',
               'Gimlet',
               'Sazerac',
               'Pimm\'s Cup',
               'Mimosa',
               'Paloma',
               'Sidecar',
               'Mint Julep',
               'Daiquiri',
               'Dark & Stormy',
               'Martinez',
               'Caipirinha']

drink_names.each do |name|
  cocktail = Cocktail.create!(name: name)
  puts "Mixing a #{cocktail.name}..."
end

puts 'Drinks successfully mixed!'
puts ''

puts 'Preparing some doses...'
sleep(1)

quantities = ['3 spoons', '200ml', '100ml', '30ml', '2 leaves']

50.times do
  cocktail = Cocktail.all.sample
  ingredient = Ingredient.all.sample
  description = quantities.sample

  Dose.create(description: description,
              cocktail: cocktail,
              ingredient: ingredient)
end

puts 'Doses successfully created!'
puts ''

puts 'Writing some reviews'
sleep(1)

40.times do
  cocktail = Cocktail.all.sample
  content = Faker::ChuckNorris.fact
  rating = (1..5).to_a.sample
  Review.create!(content: content,
                 rating: rating,
                 cocktail: cocktail)
end

puts 'Reviews successfully created!'
puts ''
