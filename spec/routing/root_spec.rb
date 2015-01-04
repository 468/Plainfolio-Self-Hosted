require 'rails_helper'

RSpec.describe "Root", :type => :routing do
  it "routes portfolios#index to '/'" do
    expect(:get => "/").to route_to(
      :controller => "portfolios",
      :action => "index",
    )
  end

  it "routes portfolios#index to root_path" do
    expect(:get => root_path).to route_to(
      :controller => "portfolios",
      :action => "index",
      )
  end
end
