FactoryBot.define do
  
  factory :autorization do
    provider "MyString"
    uid "MyString"
    user_id 1
  end
  factory :user3,class: UserOmniauth do
    name "Mihai Zapodeanu"
    email "zapo93@hotmail.it"
  end

  factory :user do
    username  "Marco"
    email     "marco@gmail.com"
    password  "12341234"
    password_confirmation  "12341234"
  end
  
  factory :user2, class: User do
    username  "Marcolinooooooo"
    email     "marco1@gmail.com"
    password  "12341234"
    password_confirmation  "12341234"
  end

  factory :user3, class: User do
    username "DajeGiggiooo"
    email "Dajegiggio@gmail.com"
    password "12341234"
    password_confirmation "12341234"
  end

  factory :owner, class: User do
    username  "Owner"
    email     "Owner@gmail.com"
    password  "12341234"
    password_confirmation  "12341234"
  end
  
  
  factory :valid_room, class: Room do
    name             'Abaco'
    max_participants 1 
    time_from        Time.now + 60*60*12
    time_to          Time.now + 60*70*24
  end
  
  factory :invalid_room, class: Room do
    name             'Abaco'
    max_participants 1 
    time_from        Time.now - 60
    time_to          Time.now + 60
  end
  
  factory :invalid_room_param, class: Room do
    name             'Abac24342384903849034852490841094709184132o'
    time_from        Time.now - 60
    time_to          Time.now + 6000
  end
end

