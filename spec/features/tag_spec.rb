require 'rails_helper'
require 'spec_helper'
require 'features/helpers'
include Helpers
include Capybara::DSL

feature 'Tag' do

  let!(:admin) { FactoryGirl.create(:admin) }
  let!(:portfolio) { FactoryGirl.create(:portfolio, admin: admin) }
  let!(:entry) {FactoryGirl.create(:entry, column: portfolio.columns.second, title: 'untagged entry')}
  let!(:tagged_entry) {FactoryGirl.create(:entry, column: portfolio.columns.second, title: 'tagged entry')}
  let!(:tag) {FactoryGirl.create(:tag, portfolio: portfolio, name: 'test_tag')}

  def setup
    tagged_entry.tags << tag
  end

  scenario 'should filter entries when clicked (minus first column)' do
  	setup
  	visit portfolio_path(portfolio)
  	click_link('test_tag')
  	expect(page).to have_text("tagged entry")
  	expect(page).to_not have_text("untagged entry")
  end

  scenario 'should unfilter posts when clicked while selected (deactivated)' do
  	setup
  	visit portfolio_path(portfolio)
  	click_link('test_tag')
  	expect(page).to_not have_text("untagged entry")
  	click_link('test_tag')
  	expect(page).to have_text("tagged entry")
  	expect(page).to have_text("untagged entry")
  end

  scenario 'should be shown on entry page' do
  	setup
  	visit portfolio_entry_path(portfolio, tagged_entry)
  	expect(page).to have_text("test_tag")
  end


end