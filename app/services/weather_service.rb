class WeatherService
	def get_forecast(weather_params)
		get_url("/v1/current.json", weather_params[:location], weather_params[:air_quality])
	end

	def get_url(url, location, air_quality)
		response = conn.get(url) do |f|
			f.params[:q] = location
			f.params[:aqi] = air_quality
			f.params[:key] = Rails.application.credentials.open_weather[:api_key]
		end
		JSON.parse(response.body, symbolize_names: true)
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