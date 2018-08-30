User.create!(username:  "Example User",
    email: "example@railstutorial.org",
    password:              "foobarzoo",
    password_confirmation: "foobarzoo",
    admin:     true,
    activated: true,
    activated_at: Time.zone.now
    )

99.times do |n|
name  = Faker::Name.name
email = "example-#{n+1}@railstutorial.org"
password = "password"
User.create!(username:  name,
     email: email,
     password:              password,
     password_confirmation: password,
     activated: true,
     activated_at: Time.zone.now
    )
end