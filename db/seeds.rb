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
               'Martinez']

drinks_urls = ['https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/old-fashioned-1592951230.jpg',
               'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/margarita-1592951298.jpg',
               'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/cosmopolitan-1592951320.jpg',
               'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/negroni-1592951342.jpg',
               'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/moscow-mule-1592951361.jpg',
               'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/martini-1592951711.jpg',
               'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/mojito-1592951385.jpg',
               'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/whiskey-sour-1592951408.jpg',
               'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/french-75-1592951630.jpg',
               'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/manhattan-1592951428.jpg',
               'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/milano-spritzer-1593008325.jpg',
               'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/gimlet-1592951479.jpg',
               'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/sazerac-1592951496.jpg',
               'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/pimms-cup-1592951518.jpg',
               'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/mimosa-1592951449.jpg',
               'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/paloma-1592951544.jpg',
               'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/sidecar-1592951563.jpg',
               'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/mint-julep-1592951594.jpg',
               'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/daiquiri-1592951739.jpg',
               'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/dark-n-stormy-1592951763.jpg',
               'https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/martinez-1592951796.jpg']

drink_names.each_with_index do |name, index|
  cocktail = Cocktail.create!(name: name)
  image = URI.open(drinks_urls[index])
  cocktail.photo.attach(io: image, filename: cocktail.name, content_type: 'image/png')

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
