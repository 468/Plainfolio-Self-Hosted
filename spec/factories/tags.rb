FactoryGirl.define do
  factory :tag do |f|
  	f.name Faker::Internet.domain_word
  	f.text_color '#fff'
  	f.background_color '#111'
  	f.association :portfolio, factory: :portfolio
  end
end