require 'rails_helper'

RSpec.describe TagsController, :type => :controller do

  let!(:admin) { FactoryGirl.create(:admin) }

  let!(:portfolio) { FactoryGirl.create(:portfolio, admin: admin) }

  let!(:tag) { FactoryGirl.create(:tag, portfolio: portfolio) }

  let!(:count) { portfolio.tags.count }

  describe "create" do
  	context "from signed in admin" do
  	  it "is successful" do
  	  	session[:admin_id] = admin.id
  	  	post :create, tag: { name: "My New tag", text_color: "#000000", background_color: "#ffffff"}, portfolio_id: portfolio.id
  	  	portfolio.reload
  	    expect(portfolio.tags.count).to eq(count+1)
  	  end
  	end

  	context "from guest" do
  	  it "is unsuccessful" do
  	  	post :create, tag: { name: "My New tag", text_color: "#000000", background_color: "#ffffff"}, portfolio_id: portfolio.id
  	  	portfolio.reload
  	    expect(portfolio.tags.count).to eq(count)
  	  end
  	end
  end

  describe "destroy" do
  	context "from signed in admin" do
  	  it "is successful" do
  	  	session[:admin_id] = admin.id
  	  	delete :destroy, portfolio_id: portfolio.id, id: tag.id
  	  	portfolio.reload
  	    expect(portfolio.tags.count).to eq(count-1)
  	  end
  	end

  	context "from guest" do
  	  it "is unsuccessful" do
  	  	delete :destroy, portfolio_id: portfolio.id, id: tag.id
        portfolio.reload
        expect(portfolio.tags.count).to eq(count)
  	  end
  	end
  end

  describe "update" do
  	context "from signed in admin" do
  	  it "is successful" do
  	  	session[:admin_id] = admin.id
  	  	put :update, tag: { name: "Updated Tag Name"}, portfolio_id: portfolio.id, id: tag.id
        tag.reload
        expect(tag.name).to eq("Updated Tag Name")
  	  end
  	end

  	context "from guest" do
  	  it "is unsuccessful" do
  	  	put :update, tag: { name: "Updated Tag Name"}, portfolio_id: portfolio.id, id: tag.id
        tag.reload
        expect(tag.name).to_not eq("Updated Tag Name")
  	  end
  	end
  end

end
