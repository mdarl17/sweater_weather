require "rails_helper"

RSpec.describe "Forecast for city", :vcr, type: :request do 
	before(:each) do 
		User.delete_all
		@user = User.create!(email: "mattyd@turing.edu", password: "pass123", password_confirmation: "pass123", api_key: SecureRandom.hex(13))
	end
	describe "Api::V0::Forecast" do
		it "retrieves weather for a city" do
			location = "denver,co"
			days = 5
			
			get "/api/v0/forecast", headers: { "Content-Type": "application/json", "Accept": "application/json"},
				params: { location: location, days: days }
			parsed_response = JSON.parse(response.body, symbolize_names: true)
			expect(response).to have_http_status(200)
			expect(parsed_response).to have_key(:data)
			expect(parsed_response[:data].keys).to match_array([:id, :type, :attributes])
			expect(parsed_response[:data][:id]).to eq("null")
			expect(parsed_response[:data][:type]).to eq("forecast")
			expect(parsed_response[:data][:attributes]).to be_a Hash
			expect(parsed_response[:data][:attributes].keys).to match_array([:id, :type, :current_weather, :daily_weather, :hourly_weather])
			expect(parsed_response[:data][:attributes][:id]).to eq("null")
			expect(parsed_response[:data][:attributes][:current_weather]).to be_a Hash
			expect(parsed_response[:data][:attributes][:current_weather].keys).to match_array(
				[:last_updated, :temperature, :feels_like, :humidity, :uvi, :visibility, :condition]
			)
			expect(parsed_response[:data][:attributes][:current_weather][:last_updated]).to be_a String
			expect(parsed_response[:data][:attributes][:current_weather][:temperature]).to be_a String
			expect(parsed_response[:data][:attributes][:current_weather][:feels_like]).to be_a(String).or(be_nil)
			expect(parsed_response[:data][:attributes][:current_weather][:humidity]).to be_an Integer
			expect(parsed_response[:data][:attributes][:current_weather][:uvi]).to be_a Float
			expect(parsed_response[:data][:attributes][:current_weather][:visibility]).to be_a Float
			expect(parsed_response[:data][:attributes][:current_weather][:condition]).to be_a Hash
			expect(parsed_response[:data][:attributes][:current_weather][:condition].keys).to match_array([:text, :icon])
			expect(parsed_response[:data][:attributes][:current_weather][:condition][:text]).to be_a String
			expect(parsed_response[:data][:attributes][:current_weather][:condition][:icon]).to be_a String
		end
	end
end 