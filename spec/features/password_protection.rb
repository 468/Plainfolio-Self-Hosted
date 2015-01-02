require "rails_helper"
require 'spec_helper'
require 'features/helpers'
include Helpers

# password protection settings tested in portfolio_settings_spec.rb

feature "portfolio protection" do

  feature "when enabled" do

  	let!(:admin) { FactoryGirl.create(:admin) }
    let!(:portfolio) { FactoryGirl.create(:portfolio, admin: admin) }
    before do
      portfolio.update(passworded: true, password:'secret')
    end

    scenario "shouldn't appear for portfolio owner" do
  	  sign_in(admin.email,admin.password)
      visit portfolio_path(portfolio)
      expect(page).to_not have_text("This portfolio is password protected")
    end

    scenario "should appear for non-logged in visitor" do
      visit portfolio_path(portfolio)
      expect(page).to have_text("Please enter the password below")
    end

    scenario "should let visitor sign in with correct password" do
      visit portfolio_path(portfolio)
      fill_in('portfolio_password[portfolio_password]', :with => 'secret')
      click_button('Submit')
      expect(page).to_not have_text("This portfolio is password protected")
    end

    scenario "should not let visitor in with incorrect password" do
      visit portfolio_path(portfolio)
      fill_in('portfolio_password[portfolio_password]', :with => 'wrong')
      click_button('Submit')
      expect(page).to have_text("Incorrect password")
    end
  end

  feature "when disabled" do
  	let!(:portfolio) { FactoryGirl.create(:portfolio, passworded: false) }
  	scenario "shouldn't block visitor" do
  	  visit portfolio_path(portfolio)
  	  expect(page).to_not have_text("This portfolio is password protected")
  	end
  end

end