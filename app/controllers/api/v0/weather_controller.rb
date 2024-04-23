class Api::V0::WeatherController < ApplicationController
	# def show
	# 	facade = WeatherFacade.new
	# 	weather = facade.weather(params[:location])
	# 	render json: WeatherSerializer.new(weather)
	# end

	def forecast
		facade = WeatherFacade.new(q: params[:q], aqi: params[:aqi])
		forecast = facade.forecast

		render json: WeatherSerializer.new(forecast)
	end
end