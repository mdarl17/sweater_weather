class WeatherService
	def get_current_data(coords)
		response = conn.get("/v1/current.json") do |f|
			f.params[:q] = coords
		end
		JSON.parse(response.body, symbolize_names: true)
	end

	def get_daily_data(coords, days)
		response = conn.get("/v1/forecast.json") do |f|
			f.params[:q] = coords
			f.params[:days] = days
		end
		JSON.parse(response.body, symbolize_names: true)[:forecast][:forecastday]
	end

	def get_hourly_data(coords, days)
		result = []
		response = conn.get("/v1/forecast.json") do |f|
			f.params[:q] = coords
			f.params[:days] = days
		end
		
		parsed = JSON.parse(response.body, symbolize_names: true)

		(days.to_i).times do |n|
			day = parsed[:forecast][:forecastday][n][:hour].map do |h|
				{
					time: h[:time],
					temp: h[:temp_f],
					condition: h[:condition][:text]
				}
			end
			result << day
		end
		result
	end

	def conn
		Faraday.new(url: "https://api.weatherapi.com") do |f|
			f.headers = {
				"Content-Type": "application/json",
				"Accept": "application/json"
			}
			f.params[:key] = Rails.application.credentials.weather[:api_key]
		end
	end
end