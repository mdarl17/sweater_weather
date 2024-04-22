class Api::V1::WeatherController < ApplicationController
	def show
		facade = WeatherFacade.new
		weather = facade.weather(params[:location])
		render json: WeatherSerializer.new(weather)
	end
end