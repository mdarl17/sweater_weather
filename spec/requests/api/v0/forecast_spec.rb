require "rails_helper"

RSpec.describe "Forecast for city", :vcr, type: :request do 
	describe "Api::V0::Forecast" do 
		it "retrieves weather for a city" do
			location = "cincinnati,ohio"
			air_quality = false
			get "/api/v0/forecast",
				headers: { "Content-Type": "application/json"},
				params: { q: location, aqi: air_quality }

			parsed_response = JSON.parse(response.body, symbolize_names: true)

			expect(response).to have_http_status(200)
			expect(parsed_response).to have_key(:data)
			expect(parsed_response[:data].keys).to match_array([:id, :type, :attributes])
			expect(parsed_response[:data][:id]).to eq("null")
			expect(parsed_response[:data][:type]).to eq("forecast")
			expect(parsed_response[:data][:attributes]).to be_a Hash
		end
	end
end 