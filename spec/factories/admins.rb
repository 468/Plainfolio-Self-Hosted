FactoryGirl.define do
  sequence :email do |n|
    "email#{n}@example.com"
  end

  factory :admin do |f|
    email
    password = Faker::Internet.password(8)
    f.password password
    f.password_confirmation password
  end
end