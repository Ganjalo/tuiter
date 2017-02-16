User.create!(name:                  "Admin",
             email:                 "example@railstutorial.org",
             password:              "password",
             password_confirmation: "password",
             admin:                  true,
             activated:              true,
             activated_at:           Time.zone.now)

5.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:                  name,
               email:                 email,
               password:              password,
               password_confirmation: password,
               activated:             true,
               activated_at:          Time.zone.now)
end

# Microposts
content = Array.new
25.times do
  content << Faker::ChuckNorris.fact
end
users = User.order(:created_at).take(6)
7.times do
  users.each { |user| user.microposts.create!(content: content.sample) }
end

# Following relationships
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
