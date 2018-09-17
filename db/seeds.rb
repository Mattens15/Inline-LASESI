# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
3.times do |i|
	User.create!(username: "giggio#{i}", email: "giggio123#{i}@ciao.iu", password: 'ciaociaociao', password_confirmation: 'ciaociaociao')

end

6.times do |r|
	user=User.first
	puts "Creo room #{r}"
	user.rooms.create!(name: 'Prova', max_participants: 12, time_from: Time.now + 60*60*24*30, time_to: Time.now + 60*60*24*30)
end