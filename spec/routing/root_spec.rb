require 'rails_helper'

RSpec.describe "Root", :type => :routing do
  it "routes home#index to '/'" do
    expect(:get => "/").to route_to(
      :controller => "home",
      :action => "index",
    )
  end

  it "routes home#index to root_path" do
    expect(:get => root_path).to route_to(
      :controller => "home",
      :action => "index",
      )
  end
end
