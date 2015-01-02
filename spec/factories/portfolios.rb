FactoryGirl.define do

  factory :portfolio do |f|
  	f.title Faker::Internet.domain_word
  	f.font 'arial'
  	f.url 'http://www.example.com'
  	f.association :admin, factory: :admin
  end
end