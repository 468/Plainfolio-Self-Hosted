require 'rails_helper'
require 'spec_helper'
require 'features/helpers'
include Helpers

 feature 'tag management page' do

  let!(:admin) { FactoryGirl.create(:admin) }
  let!(:portfolio) { FactoryGirl.create(:portfolio, admin: admin) }

  scenario 'should let admin create tag' do
    sign_in(admin.username,admin.password)
    visit tags_path
    within('#new_tag') do
      fill_in('tag[name]', :with => 'test tag')
      fill_in('tag[background_color]', :with => '#555')
      fill_in('tag[text_color]', :with => '#999')
      click_button('Create Tag')
    end
    expect(page).to have_text("test tag")
  end

  scenario 'should reload form & show error message when invalid data sent' do
    sign_in(admin.username,admin.password)
    visit tags_path
    within('#new_tag') do
      fill_in('tag[name]', :with => '')
      fill_in('tag[background_color]', :with => '#5453555')
      fill_in('tag[text_color]', :with => '#4543999')
      click_button('Create Tag')
    end
    expect(page).to have_text("Name can't be blank")
    expect(page).to have_text("Text color is invalid")
  end

  scenario 'should let admin delete tag' do
    sign_in(admin.username,admin.password)
    visit tags_path
    click_link('Delete Tag')
    expect(page).to have_text("Tag deleted.")
    expect(portfolio.tags.count).to eq(0)
  end


  scenario 'should let admin edit tag' do
    sign_in(admin.username,admin.password)
    visit tags_path
    within('.tag-edit-box') do
      fill_in('tag[name]', :with => 'New Tag Name')
      click_button('Update Tag')
    end
    expect(page).to have_text("New Tag Name")
    expect(portfolio.tags.first.name).to eq('New Tag Name')
  end

  scenario 'should load tag management page correctly when zero tags exist' do
    portfolio.tags.each {|tag| tag.destroy }
    expect(portfolio.tags.count).to eq(0)
    sign_in(admin.username,admin.password)
    visit tags_path
    expect(page).to have_text("No tags currently exist.")
  end

end