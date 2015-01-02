require 'rails_helper'

RSpec.describe Entry, :type => :model do
  it "has a valid factory" do
    expect(FactoryGirl.create(:entry)).to be_valid
  end

  let (:entry) {FactoryGirl.create(:entry)}
  subject { entry }
  it { should belong_to(:column) }
  it { should belong_to(:portfolio) }
  it { should validate_presence_of(:column) }
  it { should validate_presence_of(:portfolio) }
  it { should have_and_belong_to_many(:tags) }
  it { should_not allow_value("", nil).for(:title) }
  it { should allow_value("", nil).for(:summary) }
  it { should allow_value("", nil).for(:content) }

  it "should reject titles that are too long" do
  	expect(FactoryGirl.build(:entry, title: 'a'*300)).to be_invalid
  end

  it "should reject summaries that are too long" do
  	expect(FactoryGirl.build(:entry, summary: 'a'*100001)).to be_invalid
  end

  it "should reject content that is too long" do
  	expect(FactoryGirl.build(:entry, content: 'a'*100001)).to be_invalid
  end

  it "should be taggable" do
  	admin = FactoryGirl.create(:admin)
  	portfolio = FactoryGirl.create(:portfolio, admin: admin)
  	tagged_entry = FactoryGirl.create(:entry, column: portfolio.columns.last)
  	tagged_entry.tags << FactoryGirl.build(:tag, portfolio: portfolio)
  	expect(tagged_entry.tags.count).to be 1
  end

  it "should automatically format external URL without http/https" do
    a = FactoryGirl.create(:entry, external_title_link: true, external_url: 'example.com')
    expect(a.external_url == 'http://example.com').to be true
  end

end
