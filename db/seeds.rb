# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Blog posts and comments:
# 50.times do
#   date = Faker::Date.between(5.years.ago, Date.today)
#   p = Post.create(title: Faker::StarWars.quote,
#               body: Faker::Hipster.paragraph,
#               created_at: date,
#               updated_at: Faker::Date.between(date, Date.today))
#   rand(5).times do
#     cdate = Faker::Date.between(date, Date.today)
#     Comment.create(post_id: p.id,
#                     body: Faker::Hacker.say_something_smart,
#                     created_at: cdate,
#                     updated_at: Faker::Date.between(cdate, Date.today))
#   end

# Users:
50.times do
  u = User.create(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Name.name,
    password: Faker::Internet.password
  )



end