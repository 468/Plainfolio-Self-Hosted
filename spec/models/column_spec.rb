require 'rails_helper'

RSpec.describe Column, :type => :model do

  it "has a valid factory" do
    expect(FactoryGirl.create(:column)).to be_valid
  end

  let (:column) {FactoryGirl.create(:column)}
  subject { column }
  it { should belong_to(:portfolio) }
  it { should have_many(:entries) }
  it { should validate_presence_of(:portfolio) }
  it { should validate_presence_of(:background_color) }
  it { should validate_presence_of(:text_color) }
  it { should respond_to(:get_entries) }
  it { should respond_to(:toggle_show) }

  it "should be invalid when not linked to portfolio" do
	  expect(FactoryGirl.build(:column, portfolio: nil)).to be_invalid
  end

  it "should reject non-numerical entries_per_page" do
  	expect(FactoryGirl.build(:column, entries_per_page: "Not a number")).to be_invalid
  end

   it "should reject too large a number for entries_per_page" do
  	expect(FactoryGirl.build(:column, entries_per_page: "250")).to be_invalid
  end

  it "should allow name to be blank" do
  	expect(FactoryGirl.build(:column, name:"")).to be_valid
  end

  it "shouldn't allow name to be too long" do
  	expect(FactoryGirl.build(:column, name:"a"*5000)).to be_invalid
  end

  it "should accept 3-digit hex codes for background/text color" do
    expect(FactoryGirl.build(:tag, text_color: "#fff")).to be_valid
  end

  it "should accept 6-digit hex codes for background/text color" do
    expect(FactoryGirl.build(:tag, text_color: "#ffffff")).to be_valid
  end

  it "should reject non-hex codes for background/text color" do
    expect(FactoryGirl.build(:tag, text_color: "#1533")).to be_invalid
  end

  it "should toggle column show boolean with toggle_show method" do
    c = FactoryGirl.create(:column, show: true)
    c.toggle_show
    expect(c.show).to be false
  end

  describe "entries" do
  	it "should be buildable" do
  	  a = FactoryGirl.create(:column)
  	  entry = a.entries.build(title:"test",summary:"test", portfolio: a.portfolio)
  	  entry.save
  	  expect(a.entries.count).to be >0
  	end

  	it "should be retrievable with get_entries(tag_name_optional)" do
  	  b = FactoryGirl.create(:column)
  	  tag = FactoryGirl.create(:tag, name:"test", portfolio: b.portfolio)
  	  entry = b.entries.create(title:"test",summary:"test", portfolio: b.portfolio) 
  	  entry2 = b.entries.create(title:"test2",summary:"test2", portfolio: b.portfolio)
  	  entry.tags << tag

  	  expect(b.get_entries.length).to be 2
  	  expect(b.get_entries('test')).to include (entry)
  	  expect(b.get_entries('test')).to_not include (entry2)
  	end
  end

end
