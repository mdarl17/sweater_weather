require "rails_helper"

RSpec.describe "Road Trip", :vcr, type: :request do 
	it "given start and destination cities, it travel time, and arival weather" do
		origin = "denver,co"
		destination = "telluride,co"

 		get "/api/v0/road_trips", headers: { "Content-Type": "application/json ", "Accept": "application/json"}, params: { origin: origin, destination: destination }
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
		expect(parsed[:data][:attributes].first.keys).to match_array([:estimated_arrival, :estimated_condition, :estimated_temp, :trip_time])
		expect(parsed[:data][:attributes].first[:estimated_arrival]).to be_a String
		expect(parsed[:data][:attributes].first[:estimated_temp]).to be_a String
		expect(parsed[:data][:attributes].first[:estimated_condition]).to be_a String
		expect(parsed[:data][:attributes].first[:trip_time]).to be_a String
	end
end 