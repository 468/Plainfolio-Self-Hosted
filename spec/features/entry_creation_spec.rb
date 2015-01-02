require "rails_helper"
require 'spec_helper'
require 'features/helpers'
include Helpers

feature "Entry creation" do

  let!(:admin) { FactoryGirl.create(:admin) }
  let!(:portfolio) { FactoryGirl.create(:portfolio, admin: admin) }

  scenario "should post new entry to portfolio page" do
    create_entry(admin, portfolio, 'test title', 'test summary')
    expect(page).to have_text("test title")
    expect(page).to have_text("test summary")
    expect(portfolio.entries.first.title).to eq('test title')
    expect(portfolio.entries.first.summary).to eq('test summary')
  end

  scenario "should allow entry to be tagged" do
    create_entry(admin, portfolio, 'test title', 'test summary', false)
    page.check('entry_tag_ids_')
    click_button('Create Entry')
    expect(portfolio.entries.first.tags.count).to be >0
  end

  scenario "should have title link to interior page if option is checked" do
    create_entry(admin, portfolio, 'test title 3', 'test summary 3', false)
    page.check('entry_title_link')
    fill_in('entry[content]', :with => 'test entry interior content')
    click_button('Create Entry')
    expect(page).to have_text("test title 3")
    entry = portfolio.entries.first
    expect(page).to have_link('test title 3', href: entry_path(entry))
  end

  scenario "should have title link to exterior page if option is checked" do
    create_entry(admin, portfolio, 'test title 4', 'test summary 4', false)
    page.check('entry_external_title_link')
    fill_in('entry[external_url]', :with => 'http://www.example.com')
    click_button('Create Entry')
    expect(page).to have_text("test title 4")
    entry = portfolio.entries.first
    expect(page).to have_link('test title 4', href: 'http://www.example.com')
  end

  scenario "should sticky entry if option is checked" do
    create_entry(admin, portfolio, 'first entry, stickied', 'first entry', false)
    page.check('entry[sticky]')
    click_button('Create Entry')
    create_entry(admin, portfolio, 'second entry, not stickied', 'second entry', true, true)
    within first(".entry") do
      expect(page).to have_css('.fa-asterisk')
      expect(page).to have_text('first entry, stickied')
    end
  end

  scenario "should have interior content displayed on interior page only" do
    create_entry(admin, portfolio, 'test title 3', 'test summary 3', false)
    page.check('entry_title_link')
    fill_in('entry[content]', :with => 'test entry interior content')
    click_button('Create Entry')
    expect(page).to_not have_text("test entry interior content")
    click_link('test title 3')
    expect(page).to have_text("test entry interior content")
  end

  scenario "should accept basic html formatting in summary body" do
    create_entry(admin, portfolio, 'test title 3', "<a href='http://example.com'>test_link</a> <img src='example.jpg'></img>")
    expect(page).to have_link('test_link', href: 'http://example.com')
    expect(page.html).to include("example.jpg")
  end

  scenario "should accept basic html formatting in content body" do
    create_entry(admin, portfolio, 'title filler', "summary filler", false)
    page.check('entry_title_link')
    fill_in('entry[content]', :with => "<a href='http://example.com'>content_link</a> <img src='example2.jpg'></img>")
    click_button('Create Entry')
    click_link('title filler')
    expect(page).to have_link('content_link', href: 'http://example.com')
    expect(page.html).to include("example2.jpg")
  end

  scenario "should not sanitize youtube embed" do
    create_entry(admin, portfolio, 'test title', "<iframe width='560' height='315' src='//www.youtube.com/embed/PBXS0f7GqA0?rel=0' frameborder='0' allowfullscreen></iframe>")
    expect(page.html).to include("PBXS0f7GqA0")
  end

  scenario "should not sanitize vimeo embed" do
    create_entry(admin, portfolio, 'test title', "<iframe src='//player.vimeo.com/video/110094203' width='500' height='281' frameborder='0' webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe> <p><a href='http://vimeo.com/110094203'>Lorem Ipsum</a> from <a href='http://vimeo.com/admin33622400'>Lorem Ipsum</a> on <a href='https://vimeo.com'>Vimeo</a>.</p>")
    expect(page.html).to include("110094203")
  end

  scenario "should not sanitize soundcloud embed" do
    create_entry(admin, portfolio, 'test title', "<iframe width='100%' height='166' scrolling='no' frameborder='no' src='https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/174437726%3Fsecret_token%3Ds-dgaNf&amp;color=ff5500&amp;auto_play=false&amp;hide_related=false&amp;show_comments=true&amp;show_admin=true&amp;show_reposts=false'></iframe>")
    expect(page.html).to include("174437726")
  end

  scenario "friendly_id title param" do
    create_entry(admin, portfolio, 'entry title', 'interior')
    expect(portfolio.entries.first.slug).to eq("entry-title")
  end

end