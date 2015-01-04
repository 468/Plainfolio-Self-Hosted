require "rails_helper"
require 'spec_helper'
require 'features/helpers'
include Helpers

feature "Portfolio settings" do

  let!(:admin) { FactoryGirl.create(:admin) }
  let!(:portfolio) { FactoryGirl.create(:portfolio, admin: admin) }

  scenario "menu should show when portfolio owner signed in" do
  	sign_in(admin.username,admin.password)
    visit portfolios_path
    expect(page).to have_text("Portfolio Settings")
  end

  scenario "menu should not show when admin not signed in" do
  	visit portfolios_path
    expect(page).to_not have_text("Portfolio Settings")
  end

  scenario "Edit portfolio font" do
  	sign_in(admin.username,admin.password)
    visit portfolios_path
    within('#portfolio-font-form') do
 	    select 'Garamond', from: "portfolio[font]"
      select 16, from: "portfolio[font_size]"
 	    click_button('Save')
 	  end
 	  expect(page).to have_text("Portfolio was successfully updated.")
   	expect(portfolio.reload.font).to eq('garamond')
    expect(portfolio.reload.font_size).to eq(16)
  end

  feature "output settings" do
    let!(:admin) { FactoryGirl.create(:admin) }
    let!(:portfolio) { FactoryGirl.create(:portfolio, admin: admin) }

    scenario "should let admin change pdf to disabled" do
      sign_in(admin.username,admin.password)
      visit portfolios_path
      within('#output-settings-form') do
        page.uncheck('portfolio[pdf_enabled]')
        click_button('Save')
      end
      expect(page).to_not have_css("#pdf-button")
    end

    scenario "should let admin change pdf to enabled" do
      portfolio.update(pdf_enabled: false)
      sign_in(admin.username,admin.password)
      visit portfolios_path
      expect(page).to_not have_content("#pdf-button")
      within('#output-settings-form') do
        page.check('portfolio[pdf_enabled]')
        click_button('Save')
      end
      expect(page).to have_css("#pdf-button")
    end

    scenario "should let admin change rss to enabled" do
      sign_in(admin.username,admin.password)
      visit portfolios_path
      within('#output-settings-form') do
        page.check('portfolio[rss_enabled]')
        click_button('Save')
      end
      visit portfolios_path
      expect(page).to have_css("#rss-button")
    end

    scenario "should let admin change rss to disabled" do
      portfolio.update(rss_enabled: true)
      sign_in(admin.username,admin.password)
      visit portfolios_path
      within('#output-settings-form') do
        page.uncheck('portfolio[rss_enabled]')
        click_button('Save')
      end
      visit portfolios_path
      expect(page).to_not have_css("#rss-button")
    end

  end

  feature "Password protection" do

  	let!(:admin) { FactoryGirl.create(:admin) }
  	let!(:portfolio) { FactoryGirl.create(:portfolio, admin: admin) }

    scenario "should accept valid password" do
      sign_in(admin.username,admin.password)
      visit portfolios_path
      within('#password-settings-form') do
      	page.check('portfolio[passworded]')
 	  	  fill_in('portfolio[password]', :with => 'test')
 	  	  click_button('Save')
      end
      expect(page).to have_text("Portfolio was successfully updated.")
      expect(portfolio.reload.passworded?).to eq(true)
 	  end

    scenario "should reject invalid password" do
      sign_in(admin.username,admin.password)
      visit portfolios_path
      within('#password-settings-form') do
        page.check('portfolio[passworded]')
        fill_in('portfolio[password]', :with => '')
        click_button('Save')
      end
      expect(page).to have_text("Password is too short")
      expect(portfolio.reload.password_digest).to eq(nil)
      expect(portfolio.reload.passworded?).to eq(false)
    end

   	scenario "should wipe password upon disable" do
      portfolio.update(passworded: true, password:'hello')
      sign_in(admin.username,admin.password)
      visit portfolios_path
      within('#password-settings-form') do
        page.uncheck('portfolio[passworded]')
        click_button('Save')
      end
      expect(page).to have_text("Portfolio was successfully updated.")
      expect(portfolio.reload.password_digest).to eq(nil)
      expect(portfolio.reload.passworded?).to eq(false)
    end
  end

  feature "Change URL" do
    let!(:admin) { FactoryGirl.create(:admin) }
    let!(:portfolio) { FactoryGirl.create(:portfolio, admin: admin) }

    scenario "should change url" do
      sign_in(admin.username,admin.password)
      visit portfolios_path
      within('#url-settings-form') do
        fill_in('portfolio[url]', :with => 'mynewurl.com')
        click_button('Save')
      end
      expect(page).to have_text("Portfolio was successfully updated.")
      expect(portfolio.reload.url).to eq('mynewurl.com')
    end

  end
end