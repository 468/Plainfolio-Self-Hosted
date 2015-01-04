require "rails_helper"
require 'spec_helper'
require 'features/helpers'
include Helpers

feature "Entry" do

  let!(:admin) { FactoryGirl.create(:admin) }
  let!(:portfolio) { FactoryGirl.create(:portfolio, admin: admin) }
  let!(:column) { portfolio.columns.second}
  let!(:entry) { FactoryGirl.create(:entry, column: column, title: 'Testing') }

  scenario "should be editable" do
    sign_in(admin.username,admin.password)
    visit edit_entry_path(entry)
    fill_in('entry[title]', :with => 'Updated title')
    fill_in('entry[summary]', :with => 'Updated summary')
    click_button('Update Entry')
    expect(page).to have_text('Updated title')
    expect(page).to have_text('Updated summary')
  end

  scenario "should be untaggable" do
    entry.tags << FactoryGirl.create(:tag, name: 'test tag')
    sign_in(admin.username,admin.password)
    visit edit_entry_path(entry)
    page.uncheck('entry[tag_ids][]') 
    click_button('Update Entry')
    expect(page).to_not have_content('test tag')
  end

  scenario "should be deletable" do
  	sign_in(admin.username,admin.password)
    visit edit_entry_path(entry)
    click_button('Delete Entry')
    expect(page).to_not have_text('Testing')
  end

end

