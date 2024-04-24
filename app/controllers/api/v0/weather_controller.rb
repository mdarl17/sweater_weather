class Api::V0::WeatherController < ApplicationController
	def forecast
		facade = WeatherFacade.new(q: params[:q], days: params[:days])
		weather = facade.weather
		render json: WeatherSerializer.new(weather)
	end
end