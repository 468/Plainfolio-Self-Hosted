require "rails_helper"
require 'features/helpers'
include Helpers

feature "Best in place" do

  let!(:admin) { FactoryGirl.create(:admin) }
  let!(:portfolio) { FactoryGirl.create(:portfolio, admin: admin) }

  scenario "should show when portfolio owner signed in" do
  	sign_in(admin.username,admin.password)
    visit portfolios_path
    expect(page.has_css?('.fa-pencil-square')).to be true
  end
  
  scenario "should not show when admin not signed in" do
    visit portfolios_path
    expect(page.has_css?('.fa-pencil-square')).to be false
  end
end