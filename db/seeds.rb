# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'

# create default_user
User.create(
  username: 'Default User',
  email: 'default@password.com',
  password: 'default_password'
)

42.times do
  user_name = Faker::Name.unique.name
  User.create(
    username: user_name,
    email: Faker::Internet.unique.email(name: user_name),
    password: 'haketh' 
  )
end

