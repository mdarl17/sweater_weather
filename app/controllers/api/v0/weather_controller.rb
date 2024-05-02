class Api::V0::WeatherController < ApplicationController
	def forecast
		facade = WeatherFacade.new(location: params[:q], days: params[:days])
		geo_response = facade.geo_coords
		latlon = "#{geo_response.split(",")[0]},#{geo_response.split(",")[1]}"
		weather_response = WeatherFacade.new(location: latlon, days: params[:days]).weather

		if weather_response
			render json: WeatherSerializer.new(weather_response)
		else
			render error: weather_response.errors
		end
	end
end