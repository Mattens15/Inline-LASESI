# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "Creo user"
user = User.create!(username: 'Letsfed', password: '12341234', password_confirmation: '12341234', email: 'danieligno10@gmail.com')

50.times do |times|
  puts "Creo room Prova #{times}"
  user.rooms.create!(name: "Prova #{times}", description: "Prova con db seed per popolare il db",
    time_from: Time.now + 60*60*24*30, time_to: Time.now + 60*60*24*30, max_participants: 10)
end