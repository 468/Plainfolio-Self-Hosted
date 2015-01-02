require 'rails_helper'

RSpec.describe ColumnsController, :type => :controller do

  let!(:admin) { FactoryGirl.create(:admin) }
  let!(:portfolio) { FactoryGirl.create(:portfolio, admin: admin) }
  let!(:column) { portfolio.columns.second }

  describe "update" do
    context "from signed in admin" do
      it "is successful" do
        session[:admin_id] = admin.id
        put :update, column: { entries_per_page: 88}, portfolio_id: portfolio.id, id: column.id
        column.reload
        expect(column.entries_per_page).to eq(88)
      end
    end

    context "from guest" do
      it "is not successful" do
        put :update, column: { entries_per_page: 88}, portfolio_id: portfolio.id, id: column.id
        column.reload
        expect(column.entries_per_page).to_not eq(88)
      end
    end
  end

  describe "toggle_show" do
    context "from signed in admin" do
      it "is successful" do
        session[:admin_id] = admin.id
        column.update(show: true)
        post :toggle_show, portfolio_id: portfolio.id, column_id: column.id, format: :js
        column.reload
        expect(column.show?).to be false
      end
    end

    context "from signed in admin on first column" do
      it "should not be successful" do
        portfolio.columns.first.update(show: true)
        session[:admin_id] = admin.id
        post :toggle_show, portfolio_id: portfolio.id, column_id: portfolio.columns.first.id, format: :js
        column.reload
        expect(column.show?).to be true
      end
    end

    context "from guest" do
      it "is not successful" do
        column.update(show: true)
        post :toggle_show, portfolio_id: portfolio.id, column_id: column.id, format: :js
        column.reload
        expect(column.show?).to be true
      end
    end
  end

  describe "change_position" do
    context "from signed in admin" do
      it "is successful" do
        session[:admin_id] = admin.id
        post :change_position, portfolio_id: portfolio.id, column_id: column.id, new_position: 3
        column.reload
        expect(column.position).to be 3
      end
    end

    context "from signed in admin moving first column" do
      it "should not be successful" do
        session[:admin_id] = admin.id
        post :change_position, portfolio_id: portfolio.id, column_id: column.id, new_position: 0
        column.reload
        expect(column.position).to_not be 0
      end
    end

    context "from signed in admin moving to position larger than 4" do
      it "is not successful" do
        session[:admin_id] = admin.id
        post :change_position, portfolio_id: portfolio.id, column_id: column.id, new_position: 5
        column.reload
        expect(column.position).to_not be 5
      end
    end

    context "from guest" do
      it "is not successful" do
        post :change_position, portfolio_id: portfolio.id, column_id: column.id, new_position: 3
        column.reload
        expect(column.position).to_not be 3
      end
    end
  end

end
