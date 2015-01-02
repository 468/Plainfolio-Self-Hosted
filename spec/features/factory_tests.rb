require "rails_helper"
require 'spec_helper'
require 'features/helpers'
include Helpers


feature "Factories" do
	scenario "should build admin" do
	  expect(build(:admin)).to be_valid
	end

	scenario "should build column" do
	  expect(build(:column)).to be_valid
	end

	scenario "should build entry" do
	  expect(build(:entry)).to be_valid
	end

	scenario "should build portfolio" do
	  expect(build(:portfolio)).to be_valid
	end

	scenario "should build tag" do
	  expect(build(:tag)).to be_valid
	end
end