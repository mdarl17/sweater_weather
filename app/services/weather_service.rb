class WeatherService
	def get_current_data(location)
		response = conn.get("/v1/current.json") do |f|
			f.params[:q] = location
		end
		JSON.parse(response.body, symbolize_names: true)
	end

	def get_daily_data(location, days)
		response = conn.get("/v1/forecast.json") do |f|
			f.params[:q] = location
			f.params[:days] = days
			f.params[:tp] = 24
		end
		JSON.parse(response.body, symbolize_names: true)[:forecast][:forecastday]
	end

	def get_hourly_data(location)
		result = []
		24.times do |n|
			response = conn.get("/v1/forecast.json") do |f|
				f.params[:q] = location
				f.params[:hour] = n
				f.params[:days] = 1
			end
			parsed = JSON.parse(response.body, symbolize_names: true)
			result << parsed[:forecast][:forecastday].first[:hour].first
		end
		result
	end

	def conn
		Faraday.new(url: "https://api.weatherapi.com") do |f|
			f.headers = {
				"Content-Type": "application/json",
				"Accept": "application/json"
			}
			f.params[:key] = Rails.application.credentials.open_weather[:api_key]
		end
	end
end