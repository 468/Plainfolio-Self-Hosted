require 'rails_helper'

RSpec.describe EntriesController, :type => :controller do

  let!(:admin) { FactoryGirl.create(:admin) }
  let!(:portfolio) { FactoryGirl.create(:portfolio, admin: admin) }
  let!(:column) { portfolio.columns.positioned.second }
  let!(:entry) { FactoryGirl.create(:entry, column: column) }
  let!(:tag) {FactoryGirl.create(:tag, portfolio: portfolio)}

  let!(:count) { portfolio.entries.count }

  describe "create" do
  	context "from signed in admin" do
  	  it "is successful" do
  	  	session[:admin_id] = admin.id
  	  	post :create, entry: { title: "My New Entry", summary: "Summary"}, portfolio_id: portfolio.id, column_id: column.id
  	  	portfolio.reload
  	    expect(portfolio.entries.count).to eq(count+1)
  	  end
  	end

  	context "from guest" do
  	  it "is unsuccessful" do
  	  	post :create, entry: { title: "My New Entry", summary: "Summary"}, portfolio_id: portfolio.id, column_id: column.id
  	  	portfolio.reload
  	    expect(portfolio.entries.count).to eq(count)
  	  end
  	end

  end

  pending "change_column" do
    context "from signed in admin" do
      it "is successful" do
        session[:admin_id] = admin.id
        post :change_column, { entry: { column: portfolio.columns.first.id }, portfolio_id: portfolio.id, entry_title: entry.slug }, format: :js
        entry.reload
        expect(entry.column == portfolio.columns.first).to be true
      end
    end

    describe "from guest" do
      it "is not successful" do
        post :change_column, { entry: { column: portfolio.columns.first.id }, portfolio_id: portfolio.id, entry_title: entry.slug }, format: :js
        entry.reload
        expect(entry.column == portfolio.columns.first).to be false
      end
    end
  end

  describe "destroy" do
  	context "from signed in admin" do
  	  it "is successful" do
  	  	session[:admin_id] = admin.id
  	  	delete :destroy, portfolio_id: portfolio.id, title: entry.slug
  	  	portfolio.reload
  	    expect(portfolio.entries.count).to eq(count-1)
  	  end
  	end

  	context "from guest" do
  	  it "is unsuccessful" do
  	  	delete :destroy, portfolio_id: portfolio.id, title: entry.slug
  	  	portfolio.reload
  	    expect(portfolio.entries.count).to eq(count)
  	  end
  	end
  end

  describe "tagging" do
    context "with valid tag" do
      it "is successful" do
        session[:admin_id] = admin.id
        post :create, entry: { title: "valid tag test", summary: "Summary", :tag_ids => [ tag.id ]}, portfolio_id: portfolio.id, column_id: column.id
        portfolio.reload
        expect(portfolio.entries.friendly.find('valid-tag-test').tags.count).to eq(1)
      end
    end

    context "with invalid tag" do
      it "fails to create entry" do
        session[:admin_id] = admin.id
        post :create, entry: { title: "invalid tag test", summary: "Summary", :tag_ids => [ 54 ]}, portfolio_id: portfolio.id, column_id: column.id
        portfolio.reload
        expect {portfolio.entries.friendly.find('invalid-tag-test')}.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "update" do
    context "from signed in admin" do
      it "is successful" do
      	session[:admin_id] = admin.id
  	  	put :update, entry: { title: "Updated Title"}, portfolio_id: portfolio.id, title: entry.slug
        entry.reload
        expect(entry.title).to eq("Updated Title")
      end
    end

    context "from guest" do
      it "is not successful" do
  	  	put :update, entry: { title: "Updated Title"}, portfolio_id: portfolio.id, title: entry.slug
        entry.reload
        expect(entry.title).to_not eq("Updated Title")
      end
    end
  end

end
