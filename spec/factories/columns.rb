FactoryGirl.define do
  randomnumber = rand(1..100)
  position = rand(0..4)
  
  factory :column do |f|
  	f.association :portfolio, factory: :portfolio
  	f.name Faker::Internet.domain_word
  	f.background_color '#fff'
  	f.text_color '#111'
  	f.entries_per_page randomnumber
  	f.position position
  end
end