require "faker"

puts "Seeding Data"
puts "User Admin"
user = User.create(username: "admin", name: "Admin", email: "admin@mail.com", role: "admin", password: "123456")
user.avatar.attach(io: URI.open(Faker::Avatar.image(size: "50x50", format: "jpg")), filename: "user_avatar")

puts "Create Users"
(1..4).each do |i| 
user = User.create(username: Faker::Internet.username, name: Faker::Artist.name, email: Faker::Internet.email, password: "123456")
user.avatar.attach(io: URI.open(Faker::Avatar.image(size: "50x50", format: "jpg")), filename: "user_avatar_#{i}")
  puts "Tweets for user"
  2.times do
    tweet1 = Tweet.create(body: Faker::Lorem.paragraph, user: user)
    tweet2 = Tweet.create(body: Faker::Lorem.paragraph, user: user)
    puts "Replies to tweets"
    1.times do
      tweet1.replied_to << tweet2
    end
    puts "Likes to tweet"
    1.times do
      Like.create(user: user, tweet: tweet1)
      Like.create(user: user, tweet: tweet2)
    end
  end
end




