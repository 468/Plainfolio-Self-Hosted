require 'rails_helper'
require 'features/helpers'
include Helpers

feature 'admin signs up' do

  def random_username
    Faker::Internet.user_name
  end

  scenario 'with valid username, adminname and password' do
    sign_up(random_username,'password','password')
  end

  scenario 'with invalid username' do
	sign_up('invalid username','password','password')
	expect(page).to have_text("Username is invalid")
  end
  scenario 'with blank username' do
	sign_up('','password','password')
	expect(page).to have_text("Username can't be blank")
  end

  scenario 'with invalid password' do
    sign_up(random_username,'ab','ab')
	expect(page).to have_text("Password is too short")
  end

  scenario 'with invalid password conf' do
    sign_up(random_username,'password','ppassword')
	expect(page).to have_text("Password confirmation doesn't match")
  end
end