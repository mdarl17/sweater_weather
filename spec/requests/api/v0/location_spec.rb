require "rails_helper"

RSpec.describe "Get geo data", :vcr, type: :request do 
	describe "Api::V0::Location" do 
		it "it returns latitude and longitude data for a given city, state, or region" do
			get "/api/v0/locations", headers: {"Content-Type": "application/json", "Accept": "application/json "}, 
					params: { location: "90,-43" }
			
			parsed = JSON.parse(response.body, symbolize_names: true)
			expect(response).to have_http_status(200)
			expect(response.body).to be_a String
			expect(parsed).to be_a Hash
			expect(parsed).to eq({:lat=>39.10713, :lon=>-84.50413})
		end
	end
end 