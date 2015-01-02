require 'rails_helper'

RSpec.describe Tag, :type => :model do
  it "has a valid factory" do
    expect(FactoryGirl.create(:tag)).to be_valid
  end

  let (:tag) {FactoryGirl.create(:tag)}
  subject { tag }
  it { should belong_to(:portfolio) }
  it { should validate_presence_of :portfolio }
  it { should have_and_belong_to_many :entries }
  it { should validate_presence_of :name }
  it { should validate_presence_of :text_color }
  it { should validate_presence_of :background_color }

  it "should not be created without portfolio association" do
  	expect(FactoryGirl.build(:tag, portfolio: nil)).to be_invalid
  end

  it "should reject names that are too long" do
  	expect(FactoryGirl.build(:tag, name: "a"*151)).to be_invalid
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

end
