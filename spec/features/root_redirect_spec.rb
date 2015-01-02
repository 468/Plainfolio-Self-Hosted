require "rails_helper"
require 'spec_helper'
require 'features/helpers'
include Helpers

feature "Homepage visit" do

	let!(:admin) { FactoryGirl.create(:admin) }
	let!(:admin2) { FactoryGirl.create(:admin) }
  let!(:portfolio) { FactoryGirl.create(:portfolio, admin: admin) }

    scenario "should redirect to account page if signed in with portfolio" do
  	  sign_in(admin.email,admin.password)
      visit root_path
      expect(page).to have_text("Your Portfolio")
    end

    scenario "should redirect to  account page if signed in without portfolio" do
      admin.portfolio.destroy
  	  sign_in(admin.email,admin.password)
      visit root_path
      expect(page).to have_text("Create Your Portfolio")
    end

  	scenario "should show portfolio if not signed in" do
  	  visit root_path
  	  expect(page).to have_text("Example entry")
    end

end