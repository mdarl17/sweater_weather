class WeatherFacade
	attr_reader :service, :location, :days, :air_quality, :alerts

	def initialize(search_params)
		@service = WeatherService.new
		@location = search_params[:q]
		@days = search_params[:days] || 5
	end

	def weather
		loc_arr = @location.split(", ")
		latlon = [loc_arr.first, loc_arr.second]

		WeatherPoro.new(
			real_time: current_weather(latlon.join(", ")),
			hourly: hourly_weather(latlon.join(", ")),
			daily: daily_weather(latlon.join(", "), @days)
		)
	end

	def current_weather(coords)
		@service.get_current_data(coords)
	end

	def hourly_weather(coords)
		@service.get_hourly_data(coords)
	end

	def daily_weather(coords, days)
		@service.get_daily_data(coords, days)
	end
end