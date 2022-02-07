# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'faker'

# create default_user
default_user = User.create(
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

# 5 user be friends with default user 
user_friends = User.where.not(username: default_user.email).limit(5)
user_friends.each_with_index do |friend, i|
  if i.even?
    UserConnection.create(
      initiator: friend,
      recipient: default_user,
      status: :accepted
    )
  else
    UserConnection.create(
      initiator: default_user,
      recipient: friend,
      status: :accepted
    )
  end
end

# make all users create a post
User.all.each do |user|
  quote_sources = [
    -> { Faker::Movies::Hobbit.quote },
    -> { Faker::TvShows::DrWho.quote },
    -> { Faker::TvShows::SiliconValley.quote }
  ]

  user.posts.create(
    content: quote_sources.sample.call
  )
end

