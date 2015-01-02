require "rails_helper"
require 'features/helpers'
include Helpers

feature "Column settings" do

let!(:admin) { FactoryGirl.create(:admin) }
let!(:portfolio) { FactoryGirl.create(:portfolio, admin: admin) }

  scenario "menu should show when portfolio owner signed in" do
  	sign_in(admin.email,admin.password)
    visit portfolio_path(portfolio)
    expect(page).to have_text("Column Settings")
  end

  scenario "menu should not show when admin not signed in" do
  	visit portfolio_path(portfolio)
    expect(page).to_not have_text("Column Settings")
  end

  feature "Edit column colors" do

  	let!(:admin) { FactoryGirl.create(:admin) }
	  let!(:portfolio) { FactoryGirl.create(:portfolio, admin: admin) }

    scenario "with valid color" do
      sign_in(admin.email,admin.password)
      visit portfolio_path(admin.portfolio.id)
      within first(".column") do
 	    find('.btn', :text => "Column Settings")
 	    find('.edit-column-colors', text: "Edit column colors")
 	    within('.column-colors-form') do
 	      fill_in('column[background_color]', :with => '#888888')
 	      fill_in('column[text_color]', :with => '#555')
 	      click_button('Save')
 	  	end
  	  end
  	  expect(page).to have_text("Column was successfully updated.")
  	  expect(portfolio.columns.first.background_color).to eq("#888888")
 	  expect(portfolio.columns.first.text_color).to eq("#555")
    end

    scenario "with invalid color" do
      sign_in(admin.email,admin.password)
      visit portfolio_path(admin.portfolio.id)
      within first(".column") do
 	    find('.btn', :text => "Column Settings")
 	    find('.edit-column-colors', text: "Edit column colors")
 	    within('.column-colors-form') do
 	      fill_in('column[background_color]', :with => 'invalid')
 	      fill_in('column[text_color]', :with => '')
 	      click_button('Save')
 	  	end
  	  end
  	  expect(page).to_not have_text("Column was successfully updated.")
  	  expect(portfolio.columns.first.background_color).to_not eq("invalid")
 	  expect(portfolio.columns.first.text_color).to_not eq("")
    end
  end

  feature "Edit entries per page" do

  	scenario "with valid selection" do
  	  sign_in(admin.email,admin.password)
      visit portfolio_path(admin.portfolio.id)
      within first(".column") do
 	    find('.btn', :text => "Column Settings")
 	    find('.edit-entries-per-page', text: "Edit entries per page")
 	    within('.entries-per-page-form') do
 	      select '15', from: "column[entries_per_page]"
 	      click_button('Save')
 	  	end
  	  end
  	  expect(page).to have_text("Column was successfully updated.")
  	  expect(portfolio.columns.first.entries_per_page).to eq(15)
    end

  end

  feature "Hide/Unhide button" do
    # functionality for toggle_show (hide/unhide) is tested in column controller spec
  	scenario "should not seen on first column" do
  	  sign_in(admin.email,admin.password)
      visit portfolio_path(admin.portfolio.id)
      within first(".column") do
 	    find('.btn', :text => "Column Settings")
 	    expect(page).to_not have_text("Hide this column?")
 	    end
    end

  	scenario "should show hide option when column is unhidden" do
  	  sign_in(admin.email,admin.password)
      visit portfolio_path(admin.portfolio.id)
      within("#column-#{portfolio.columns.second.id}") do
 	    find('.btn', :text => "Hide this column?")
  	  end
    end

    scenario "should show unhide option when column is hidden" do
      portfolio.columns.second.update(show: false)
      sign_in(admin.email,admin.password)
      visit portfolio_path(admin.portfolio.id)
      within("#column-#{portfolio.columns.second.id}") do
 	    find('.btn', :text => "Show this column?")
  	  end
    end
  end

end