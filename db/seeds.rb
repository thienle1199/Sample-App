# Users
User.create!(name:  'Thien Le',
             email: 'thienle1144@gmail.com',
             password:              '123456',
             password_confirmation: '123456',
             admin: true,
             activated: true,
             activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::OnePiece.unique.character
  email = "example-#{n + 1}@railstutorial.org"
  password = 'password'
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,
               activated_at: Time.zone.now)
end
# Microposts
users = User.order(:created_at).take(6)
50.times do
  content = Faker::RickAndMorty.quote[0..249]
  users.each { |user| user.microposts.create!(content: content) }
end
# Following Relationships
users = User.all
user = User.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
