class LocationsService
	def get_geo_data(location)
		response = conn.get("/geocoding/v1/address") do |f|
			f.params[:location] = location
		end
		JSON.parse(response.body, symbolize_names: true)
	end

	def conn
		Faraday.new(url: "https://mapquestapi.com") do |f|
			f.headers["Content-Type"] = "application/json"
			f.headers["Accept"] = "application/json"
			f.params["key"] = Rails.application.credentials.mapquest[:api_key]
		end
	end
end