require 'rails_helper'
require 'features/helpers'
include Helpers

feature 'admin signs up' do

  def random_email
    Faker::Internet.safe_email
  end

  scenario 'with valid email, adminname and password' do
    sign_up(random_email,'password','password')
  end

  scenario 'with invalid email' do
	sign_up('invalid email','password','password')
	expect(page).to have_text("Email is invalid")
  end
  scenario 'with blank email' do
	sign_up('','password','password')
	expect(page).to have_text("Email can't be blank")
  end

  scenario 'with invalid password' do
    sign_up(random_email,'ab','ab')
	expect(page).to have_text("Password is too short")
  end

  scenario 'with invalid password conf' do
    sign_up(random_email,'password','ppassword')
	expect(page).to have_text("Password confirmation doesn't match")
  end
end