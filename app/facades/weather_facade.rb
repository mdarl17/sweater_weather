class WeatherFacade
	attr_reader :service, :location, :air_quality

	def initialize(search_params)
		@service = WeatherService.new
		@location = search_params[:q]
		@air_quality = search_params[:aqi]
	end

	def forecast
		loc = @location
		response = @service.get_forecast(location: loc, air_quality: @air_quality)
		make_weather_poro(response)
	end

	def make_weather_poro(weather_data)
		wp = WeatherPoro.new(weather_data[:location], weather_data[:current])
	end
end