class RoadTripsService
	def initialize(origin, destination)
		@origin = origin
		@destination = destination
	end

	def get_travel_time
		response = mq_conn.get( "/directions/v2/route")
		JSON.parse(response.body, symbolize_names: true)
	end

	def get_time_zones
		response = weather_conn(@origin).get("/v1/current.json")
		parsed = JSON.parse(response.body, symbolize_names: true)
		origin_tz = parsed[:loscation][:tz_id]

		response = weather_conn(@destination).get("/v1/current.json")
		parsed = JSON.parse(response.body, symbolize_names: true)
		destination_tz = parsed[:location][:tz_id]
			{
				origin_tz: origin_tz,
				destination_tz: destination_tz
			}
	end

	def mq_conn
		Faraday.new(url: "https://www.mapquestapi.com") do |f|
			f.headers["Content-Type"] = "application/json"
			f.headers["Accept"] = "application/json"
			f.params[:from] = @origin
			f.params[:to] = @destination
			f.params[:key] = Rails.application.credentials.mapquest[:api_key]
		end
	end

	def weather_conn(location)
		Faraday.new(url: "https://api.weatherapi.com") do |f|
			f.headers = {
				"Content-Type": "application/json",
				"Accept": "application/json"
			}
			f.params[:key] = Rails.application.credentials.weather[:api_key]
			f.params[:q] = location
		end
	end

	
end