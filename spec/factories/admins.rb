FactoryGirl.define do

  #skip validations
  #to_create {|instance| instance.stub(:admin_nonexistance).returns(false) }

  sequence :email do |n|
    "email#{n}@example.com"
  end

  factory :admin do |f|
  	to_create {|instance| instance.save(validate: false) }
    email
    password = Faker::Internet.password(8)
    f.password password
    f.password_confirmation password
  end


end