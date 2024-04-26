require "rails_helper"

RSpec.describe "Road Trip", :vcr, type: :request do 
	it "given start and destination cities, it travel time, and arival weather" do
		from = "denver,co"
		to = "telluride,co"

 		get "/api/v0/road_trips", headers: { "Content-Type": "application/json ", "Accept": "application/json"},
			params: { from: from, to: to }

		parsed = JSON.parse(response.body, symbolize_names: true)

		expect(response).to have_http_status(200)
		expect(parsed).to be_a Hash
		expect(parsed.keys).to eq([:data])
		expect(parsed[:data]).to be_a Hash
		expect(parsed[:data].keys).to match_array([:id, :type, :attributes])
		expect(parsed[:data][:id]).to eq("null")
		expect(parsed[:data][:type]).to be_a String
		expect(parsed[:data][:type]).to eq("road_trip")
		expect(parsed[:data][:attributes]).to be_an Array
		expect(parsed[:data][:attributes].first.keys).to match_array([:from, :to, :trip_time, :arrival_weather])
		expect(parsed[:data][:attributes].first[:from]).to be_a String
		expect(parsed[:data][:attributes].first[:from]).to eq("denver,co")
		expect(parsed[:data][:attributes].first[:to]).to be_a String
		expect(parsed[:data][:attributes].first[:to]).to eq("telluride,co")
		expect(parsed[:data][:attributes].first[:trip_time]).to be_a String
		expect(parsed[:data][:attributes].first[:arrival_weather]).to be_a String
	end
end 