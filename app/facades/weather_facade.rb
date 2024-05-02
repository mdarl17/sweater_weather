class WeatherFacade
	attr_reader :service, :location

	def initialize(loc_data)
		@location = loc_data
		@service = WeatherService.new
		@geo_coords = geo_coords
	end

	def geo_coords
		response = LocationsFacade.new(@location).lat_lon
		lat = response[:lat]
		lon = response[:lng]
		"#{lat},#{lon}"
	end

	def current_weather
		@service.get_current_data(@geo_coords)
	end

	def hourly_weather(days=5)
		@service.get_hourly_data(@geo_coords, days)
	end

	def daily_weather(days=5)
		@service.get_daily_data(@geo_coords, days)
	end
	
	def weather
		WeatherPoro.new(
			real_time: self.current_weather,
			hourly: self.hourly_weather,
			daily: self.daily_weather
		)
	end
end