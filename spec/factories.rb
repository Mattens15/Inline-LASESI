FactoryBot.define do
  factory :autorization do
    provider "MyString"
    uid "MyString"
    user_id 1
  end
  factory :user_omniauth do
    name "MyString"
    email "MyString"
  end

    factory :user, class: User do
      username  "Marco"
      email     "marco@gmail.com"
      password  "123412345"
      password_confirmation  "123412345"
    end
    
    factory :user2, class: User do
      username  "Marcolinooooooo"
      email     "marco1@gmail.com"
      password  "123412345"
      password_confirmation  "123412345"
    end
    
end
  