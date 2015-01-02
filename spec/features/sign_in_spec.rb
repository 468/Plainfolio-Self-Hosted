require 'rails_helper'
require 'features/helpers'
include Helpers

feature 'admin signs in' do
  before do
    @admin = FactoryGirl.create(:admin)
  end

  scenario 'with valid information' do
    sign_in(@admin.email, @admin.password)
    expect(page).to have_text("Sign Out")
  end

  scenario 'with invalid password' do
    sign_in(@admin.email, 'invalid')
    expect(page).to have_text("Email or password is invalid")
  end

  scenario 'with invalid email' do
    sign_in('invalid', @admin.password)
    expect(page).to have_text("Email or password is invalid")
  end

end