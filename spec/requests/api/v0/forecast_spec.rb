require "rails_helper"

RSpec.describe "Forecast for city", :vcr, type: :request do 
	describe "Api::V0::Forecast" do 
		it "retrieves weather for a city" do
			location = "Cincinnati, OH"
			days = 5

			get "/api/v0/forecast", headers: { "Content-Type": "application/json", "Accept": "application/json"},
					params: { q: location, days: days }

			parsed_response = JSON.parse(response.body, symbolize_names: true)

			expect(response).to have_http_status(200)
			expect(parsed_response).to have_key(:data)
			expect(parsed_response[:data].keys).to match_array([:id, :type, :attributes])
			expect(parsed_response[:data][:id]).to eq("null")
			expect(parsed_response[:data][:type]).to eq("forecast")
			expect(parsed_response[:data][:attributes]).to be_a Hash
			expect(parsed_response[:data][:attributes].keys).to match_array([:id, :type, :location, :current, :daily_weather, :hourly_weather])
			expect(parsed_response[:data][:attributes][:id]).to eq("null")
			expect(parsed_response[:data][:attributes][:location]).to be_a Hash
			expect(parsed_response[:data][:attributes][:location]).to eq({city: "Cincinnati", state: "OH", country: "United States"})
			expect(parsed_response[:data][:attributes][:location][:city]).to be_a String
			expect(parsed_response[:data][:attributes][:location][:state]).to be_a String
			expect(parsed_response[:data][:attributes][:location][:country]).to be_a String
			expect(parsed_response[:data][:attributes][:current]).to be_a Hash
			expect(parsed_response[:data][:attributes][:current].keys).to match_array(
				[:last_updated, :temperature, :feels_like, :humidity, :uvi, :visibility, :condition]
			)
			expect(parsed_response[:data][:attributes][:current][:last_updated]).to be_a String
			expect(parsed_response[:data][:attributes][:current][:temperature]).to be_a Float
			expect(parsed_response[:data][:attributes][:current][:feels_like]).to be_nil.or be_a Float
			expect(parsed_response[:data][:attributes][:current][:humidity]).to be_an Integer
			expect(parsed_response[:data][:attributes][:current][:uvi]).to be_a Float
			expect(parsed_response[:data][:attributes][:current][:visibility]).to be_a Float
			expect(parsed_response[:data][:attributes][:current][:condition]).to be_a Hash
			expect(parsed_response[:data][:attributes][:current][:condition].keys).to match_array([:text, :icon])
			expect(parsed_response[:data][:attributes][:current][:condition][:text]).to be_a String
			expect(parsed_response[:data][:attributes][:current][:condition][:icon]).to be_a String
		end
	end
end 