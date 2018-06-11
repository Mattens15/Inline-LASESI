FactoryBot.define do
  factory :user do
    username  "Marco"
    email     "marco@gmail.com"
    password  "12341234"
    password_confirmation  "12341234"
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
    time_from        Time.now + 60*60
    time_to          Time.now + 60*70
  end
  
  factory :invalid_room, class: Room do
    name             'Abaco'
    max_participants 1 
    time_from        Time.now - 60
    time_to          Time.now + 60
  end
end

