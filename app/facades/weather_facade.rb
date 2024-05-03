class WeatherFacade
	attr_reader :service, :location, :days

	def initialize(loc_data, days=5)
		@days = days
		@location = loc_data
		@service = WeatherService.new
	end

	def current_weather
		@service.get_current_data(@location)
	end

	def hourly_weather(days=5)
		@service.get_hourly_data(@location, days)
	end

	def daily_weather(days=5)
		@service.get_daily_data(@location, days)
	end
	
	def weather(days=@days)
		WeatherPoro.new(
			real_time: self.current_weather,
			hourly: self.hourly_weather(days),
			daily: self.daily_weather(days)
		)
	end
end