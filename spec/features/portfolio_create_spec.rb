require 'rails_helper'
require 'spec_helper'
require 'features/helpers'
include Helpers

feature "Portfolio create" do

  let!(:admin) { FactoryGirl.create(:admin) }

  scenario "rejects blank name" do
  	sign_in(admin.email,admin.password)
    visit new_portfolio_path
    fill_in('portfolio[title]', with: '')
	  click_button('Create Portfolio')
    expect(page).to have_text("Title can't be blank")
  end

  scenario "redirects to new portfolio on creation" do
    sign_in(admin.email,admin.password)
    visit new_portfolio_path
    fill_in('portfolio[title]', with: 'Test')
    fill_in('portfolio[url]', with: 'http://www.example.com')
    click_button('Create Portfolio')
    expect(page).to have_text("Example Entry")
  end

end