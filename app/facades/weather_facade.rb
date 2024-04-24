class WeatherFacade
	attr_reader :service, :location, :days, :air_quality, :alerts

	def initialize(search_params)
		@service = WeatherService.new
		@location = search_params[:q]
		@days = search_params[:days]
	end

	def weather
		geo_data = LocationsFacade.new(@location).lat_lon
		WeatherPoro.new(geocoding: geo_data, location: current_weather[:location], current: current_weather[:current], hourly: hourly_weather, daily: daily_weather)
	end

	def current_weather
		location_weather = @service.get_current_data(@location)
		{ 
			location: location_weather[:location],
			current: location_weather[:current]
		}
	end

	def hourly_weather
		hourly = @service.get_hourly_data(@location)
	end

	def daily_weather
		daily = @service.get_daily_data(@location, @days)
	end
end