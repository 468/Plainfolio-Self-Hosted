require 'rails_helper'
require 'features/helpers'
include Helpers

feature 'admin signs in' do
  before do
    @admin = FactoryGirl.create(:admin)
  end

  scenario 'with valid information' do
    sign_in(@admin.username, @admin.password)
    expect(page).to have_text("Sign Out")
  end

  scenario 'with invalid password' do
    sign_in(@admin.username, 'invalid')
    expect(page).to have_text("Username or password is invalid")
  end

  scenario 'with invalid username' do
    sign_in('invalid', @admin.password)
    expect(page).to have_text("Username or password is invalid")
  end

end