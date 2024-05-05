class Api::V0::WeatherController < ApplicationController
	def forecast
		loc_hash = LocationsFacade.new(params[:location]).lat_lon
		latlon = "#{loc_hash[:lat]},#{loc_hash[:lng]}"
		facade = WeatherFacade.new(latlon, params[:days])
		weather_response = facade.weather

		if weather_response
			render json: WeatherSerializer.new(weather_response)
		else
			render error: weather_response.errors
		end
	end
end