FactoryGirl.define do
  factory :entry do |f|
  	f.title Faker::Internet.domain_word
  	f.summary Faker::Lorem.paragraph
  	f.content Faker::Lorem.paragraph(10)
  	f.association :column, factory: :column
  	f.association :portfolio, factory: :portfolio
  end
end