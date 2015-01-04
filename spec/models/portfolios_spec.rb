require 'rails_helper'
require 'spec_helper'

RSpec.describe Portfolio, :type => :model do

  it "has a valid factory" do
  	expect(FactoryGirl.create(:portfolio)).to be_valid
  end

  let (:portfolio) {FactoryGirl.create(:portfolio)}
  subject { portfolio }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:url) }
  it { should validate_presence_of(:admin) }
  it { should belong_to(:admin) }
  it { should have_many(:columns) }
  it { should have_many(:tags) }
  it { should accept_nested_attributes_for(:columns) }
  it { should have_secure_password }
  it { should respond_to(:set_defaults) }
  it { should respond_to(:create_columns) }
  it { should respond_to(:create_example_tag) }
  it { should respond_to(:create_example_entries) }
  it { should respond_to(:as_csv) }

  it "should reject titles that are too long" do
    expect(FactoryGirl.build(:portfolio, title: 'a'*256 )).to be_invalid
  end

  it "should have default settings on creation" do
  	a = FactoryGirl.create(:portfolio)
  	expect(a.font).to eq('helvetica')
    expect(a.font_size).to eq(12)
  	expect(a.passworded).to be(false)
  	expect(a.tags.last.name).to eq("Sample Tag")
  end

  describe "set_defaults" do

  	let (:a) {FactoryGirl.create(:portfolio)}

  	it "should automatically create default columns upon creation" do
  	  expect(a.columns.count).to eq(5)
  	  expect(a.columns.positioned.first.name).to eq("About")
  	  a.columns.each_with_index do |column, index|
  		  expect(column.show).to be(true) unless index == 4
  		  expect(column.entries_per_page).to be(10) 
  		  expect(column.text_color).to eq("#111") unless index == 0
  		  expect(column.background_color).to eq("#fff") unless index == 0
  	  end
    end

    it "should enable pdf download option by default" do
      expect(a.pdf_enabled?).to be(true)
    end

    it "should automatically create default column entries upon creation" do
      expect(a.columns.positioned.first.entries.count).to eq(2)
      expect(a.columns.positioned.second.entries.count).to eq(2)
      expect(a.columns.positioned.second.entries.positioned.first.tags.count).to eq(1)
    end
  end

  describe "password protection" do

  	let (:owner) {FactoryGirl.create(:admin)}
  	let (:passworded_portfolio) {FactoryGirl.create(:portfolio)}
    before do
      passworded_portfolio.update(passworded: true, password: 'secret')
    end

  	it "should reject passwords that are incorrect length" do
  	  expect(FactoryGirl.build(:portfolio, passworded: true, password: '', admin: owner)).to be_invalid
  	  expect(FactoryGirl.build(:portfolio, passworded: true, password: 'a'*77, admin: owner)).to be_invalid
  	end

  	it "should require password to exist to enable password protection" do
  	  expect(FactoryGirl.build(:portfolio, passworded: true)).to be_invalid
  	end

  	it "should digest password" do
  	  expect(passworded_portfolio.password_digest.length).to be >1
  	  expect(passworded_portfolio.password_digest).to_not be('secret')
  	end
  	it "should clear password digest when password disabled" do
  	  passworded_portfolio.update(passworded: false)
  	  expect(passworded_portfolio.password_digest).to be(nil)
  	end

    it "should not inhibit editing of other portfolio attributes" do
      passworded_portfolio.title = 'new title'
      expect(passworded_portfolio.title).to eq('new title')
    end

  end
  
end

