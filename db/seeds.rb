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
  email: 'default@email.com',
  password: 'default@email.com'
)

70.times do
  user_name = Faker::Name.unique.name
  User.create(
    username: user_name,
    email: Faker::Internet.unique.email(name: user_name),
    password: 'default@email.com'
  )
end

# setup friends
User.no_connections(default_user).each_with_index do |friend, i|
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

# make random friendships with among other users
User.where.not(id: default_user.id).each do |user|
  # make about 5 to 17 friends with each user
  User.no_connections(user).limit(rand(0..17)).each_with_index do |friend, i|
    if i.even?
      UserConnection.create(
        initiator: friend,
        recipient: user,
        status: :accepted
      )
    else
      UserConnection.create(
        initiator: user,
        recipient: friend,
        status: :accepted
      )
    end
  end
end


# setup requests
User.no_connections(default_user).each_with_index do |suggestion, i|
  if i.even?
    UserConnection.create(
      initiator: suggestion,
      recipient: default_user,
      status: :pending
    )
  else
    UserConnection.create(
      initiator: default_user,
      recipient: suggestion,
      status: :pending
    )
  end
end

# make all users create a posts between 1 to 8 
# add variability to the post date
quote_sources = [
    -> { Faker::Movies::Hobbit.quote },
    -> { Faker::TvShows::DrWho.quote },
    -> { Faker::TvShows::SiliconValley.quote }
  ]

User.all.each do |user|

  create_time = [
    rand(1..59).minute.ago,
    rand(1..24).hour.ago,
    rand(1..31).day.ago,
    rand(1..3).month.ago,
  ]

  rand(1..8).times do
    time = create_time.sample
    user.posts.create(
      content: quote_sources.sample.call,
      created_at: time,
      updated_at: time
    )
  end
end

# setup likes, commments and shares for posts 
Post.all.each do |post|
  # make only friends of author like and share the post
  author = post.author

  author.friends.limit(12).each do |friend|
    act_on_post = [true, false, false]

    act_on_post.sample && friend.like(post)

    act_on_post.sample && friend.share(post)

    act_on_post.sample && friend.comments.create(post: p, content: quote_sources.sample.call)
  end
end