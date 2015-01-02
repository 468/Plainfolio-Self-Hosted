require 'rails_helper'

RSpec.describe PortfoliosController, :type => :controller do

  let!(:admin) { FactoryGirl.create(:admin) }
  let!(:portfolio) { FactoryGirl.create(:portfolio, admin: admin) }


  describe "update" do
    context "from signed in admin" do
      it "is successful" do
      	session[:admin_id] = admin.id
        put :update, :portfolio => {:title => "Updated Title"}, :id => portfolio.id
        portfolio.reload
        expect(portfolio.title).to eq("Updated Title")
      end
    end

    context "from guest" do
      it "is not successful" do
        put :update, :portfolio => {:title => "Updated Title"}, :id => portfolio.id
        portfolio.reload
        expect(portfolio.title).to_not eq("Updated Title")
      end
    end
  end

end
