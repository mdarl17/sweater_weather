class WeatherService
	def get_weather(location="london,en", air_quality=false)
		get_url("/v1/current.json", location, air_quality)
	end

	def get_url(url, location, air_quality)
		response = conn.get(url) do |f|
			f.params[:q] = location
			f.params[:aqi] = air_quality
			f.params[:key] = Rails.application.credentials.open_weather[:api_key]
		end
	end 	

	def conn
		Faraday.new(
			url: "https://api.weatherapi.com",
			headers: {
				"Content-Type": "application/json",
				"Accept": "application/json"
			}
		)
	end
end

w = WeatherService.new.get_weather(location="denver,co", air_quality=false)