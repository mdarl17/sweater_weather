require "rails_helper"

<<<<<<< Updated upstream
<<<<<<< Updated upstream
RSpec.describe "Road Trip", type: :type do 
	it "given start and destination cities, it travel time, and arival weather" do
		
=======
=======
>>>>>>> Stashed changes
RSpec.describe "Road Trip", type: :request do 
	it "given start and destination cities, it travel time, and arival weather" do
		origin = "denver,co"
		destination = "telluride,co"

 		get "/api/v0/road_trips", headers: { "Content-Type": "application/json ", "Accept": "application/json"},
			params: { from: origin, to: destination }

		parsed = JSON.parse(response.body, symbolize_names: true)

		expect(response).to have_http_status(200)
		expect(parsed).to be_a String
		expect(parsed.keys).to match_array()
<<<<<<< Updated upstream
>>>>>>> Stashed changes
=======
>>>>>>> Stashed changes
	end
end 