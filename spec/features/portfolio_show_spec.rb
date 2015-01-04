require "rails_helper"
require 'spec_helper'
require 'features/helpers'
include Helpers

feature "Portfolio show page" do
  
  let!(:admin) { FactoryGirl.create(:admin) }
  let!(:portfolio) { FactoryGirl.create(:portfolio, admin: admin) }

  scenario "should retrieve correct portfolio" do
  	visit portfolios_path
  	expect(page).to have_text(portfolio.title)
  end

  scenario "should not show hidden columns" do
  	portfolio.columns.positioned.second.update(show: false)
  	portfolio.columns.positioned.third.update(show: false)
  	visit portfolios_path
  	expect(page).to have_css('.column', count: 2) # default showing column count is 4
  end

  feature "pagination" do

    let!(:admin) { FactoryGirl.create(:admin) }
    let!(:portfolio) { FactoryGirl.create(:portfolio, admin: admin) }

    scenario "should limit entries shown per column to column's entries_per_page count" do
      sign_in(admin.username,admin.password)
      5.times { create_entry(admin, portfolio, 'test', 'test', true, true) }
      portfolio.columns.positioned.first.update(entries_per_page: 2)
      visit portfolios_path
      within first(".column") do
      	expect(page).to have_css('.entry', count: 2)
      end
    end

  end
end