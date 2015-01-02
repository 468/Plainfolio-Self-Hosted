require 'rails_helper'

RSpec.describe Admin, :type => :model do

  it "has a valid factory" do
  	expect(FactoryGirl.create(:admin)).to be_valid
  end

  let (:admin) {FactoryGirl.create(:admin)}
  subject { admin }
  it { should validate_presence_of(:email) }
  it { should have_one(:portfolio) }

  describe "account creation" do

    it "is valid with correct attributes" do
      admin = FactoryGirl.create(:admin)
      expect(admin).to be_valid
    end

    it "is invalid with blank password" do
      expect(FactoryGirl.build(:admin, password: "", password_confirmation: "")).to be_invalid
    end

    it "is invalid with blank email" do
      expect(FactoryGirl.build(:admin, email: "")).to be_invalid
    end

    it "is invalid with non-matching password" do
      expect(FactoryGirl.build(:admin, password: "notmatching")).to be_invalid
    end

    it "is invalid with non-unique email" do
      admin = FactoryGirl.create(:admin, email: "hello@example.com")
      expect(admin).to be_valid
      expect(FactoryGirl.build(:admin, email: "hello@example.com")).to be_invalid
    end
  end

  describe "portfolio creation" do

  	it "should be linked to associated admin" do
  	  admin = FactoryGirl.create(:admin)
  	  portfolio = admin.build_portfolio(title: 'Test', font: 'arial', url: 'http://www.example.com/')
  	  expect(portfolio.admin == admin).to be true
  	end

	it "overwrites old portfolio if new one is created by same admin" do
 	    admin = FactoryGirl.create(:admin)
  	  a = admin.create_portfolio(title: 'Test', font: 'arial', url: 'http://www.example.com/')
      b = admin.create_portfolio(title: 'Test2', font: 'arial', url: 'http://www.example.com/')
      expect(admin.portfolio).to be b
  	end

  end
end
