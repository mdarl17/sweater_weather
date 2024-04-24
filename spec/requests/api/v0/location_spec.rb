require "rails_helper"

RSpec.describe "Get geo data", type: :request do 
	describe "Api::V0::Location" do 
		it "searches for and returns geo data for a given city and state/region" do
			location = "sao paolo, brazil"
			get "/api/v0/locations", headers: {"Content-Type": "application/json", "Accept": "application/json "}, 
					params: { location: location }
		end
	end
end 