User.create!(name:  "佐藤　光一",
  email: "sample@example.com",
  password:              "foobar",
  password_confirmation: "foobar")

99.times do |n|
name  = Faker::Name.name
email = "sample-#{n+1}@example.com"
password = "password"
User.create!(name:  name,
    email: email,
    password:              password,
    password_confirmation: password)
end
