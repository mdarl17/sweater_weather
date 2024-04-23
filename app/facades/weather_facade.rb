class WeatherFacade
	attr_reader :service, :location, :air_quality
	
	def initialize(search_params)
		@service = WeatherService.new
		@location = search_params[:q]
		@air_quality = search_params[:aqi]
	end

	def forecast
		loc_array = @location.delete(" ").split(",")
		city = loc_array[0].downcase
		state = loc_array[1].downcase
		response = @service.get_forecast(location: "#{city},#{state}", air_quality: @air_quality)
		weather_poro = make_weather_poro(response)
	end

	def make_weather_poro(weather_data)
		wp = WeatherPoro.new(weather_data[:current])
	end
end