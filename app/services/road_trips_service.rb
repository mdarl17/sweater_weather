class RoadTripsService
	def get_travel_time(from, to)
		url = "https://www.mapquestapi.com""/directions/v2/route"

		response = Faraday.get(url) do |f|
			f.headers["Content-Type"] = "application/json"
			f.headers["Accept"] = "application/json"
			f.params[:from] = from
			f.params[:to] = to
			f.params[:key] = Rails.application.credentials.mapquest[:api_key]
		end
		
		JSON.parse(response.body, symbolize_names: true)
	end
end